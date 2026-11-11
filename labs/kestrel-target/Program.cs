// Local ASP.NET Core target with DEFAULT Kestrel settings, for studying how the framework parses
// and handles requests. Binds to loopback only.
//   LAB_PORT (default 5080) : HTTP/1.1
//   LAB_PORT + 1            : HTTP/2 cleartext (prior knowledge)
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text.Json;
using Microsoft.AspNetCore.Server.Kestrel.Core;

int port = int.TryParse(Environment.GetEnvironmentVariable("LAB_PORT"), out var p) ? p : 5080;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.ConfigureKestrel(o =>
{
    // Only the listeners are configured. Limits and parser behaviour are left at their defaults,
    // because a finding that needs non-default settings is unlikely to be rated Important.
    o.ListenLocalhost(port, l => l.Protocols = HttpProtocols.Http1);
    o.ListenLocalhost(port + 1, l => l.Protocols = HttpProtocols.Http2);
});
var app = builder.Build();

app.MapGet("/", () => Results.Json(new
{
    runtime = RuntimeInformation.FrameworkDescription,
    os = RuntimeInformation.OSDescription,
    arch = RuntimeInformation.OSArchitecture.ToString(),
}));

// Reports exactly what the server believes it received. Compare with the bytes you sent.
app.Map("/echo/{**rest}", async (HttpContext ctx) =>
{
    using var sha = SHA256.Create();
    long length = 0;
    var buffer = new byte[8192];
    int read;
    while ((read = await ctx.Request.Body.ReadAsync(buffer)) > 0)
    {
        sha.TransformBlock(buffer, 0, read, null, 0);
        length += read;
    }
    sha.TransformFinalBlock([], 0, 0);
    return Results.Json(new
    {
        protocol = ctx.Request.Protocol,
        method = ctx.Request.Method,
        path = ctx.Request.Path.Value,
        rawTarget = ctx.Features.Get<Microsoft.AspNetCore.Http.Features.IHttpRequestFeature>()?.RawTarget,
        query = ctx.Request.QueryString.Value,
        headers = ctx.Request.Headers.ToDictionary(h => h.Key, h => h.Value.ToArray()),
        bodyLength = length,
        bodySha256 = Convert.ToHexString(sha.Hash!),
    });
});

app.MapPost("/form", async (HttpContext ctx) =>
{
    var form = await ctx.Request.ReadFormAsync();
    return Results.Json(new
    {
        fields = form.ToDictionary(f => f.Key, f => f.Value.ToArray()),
        files = form.Files.Select(f => new { f.Name, f.FileName, f.ContentType, f.Length }),
    });
});

app.MapPost("/json", async (HttpContext ctx) =>
{
    using var doc = await JsonDocument.ParseAsync(ctx.Request.Body);
    return Results.Json(new { kind = doc.RootElement.ValueKind.ToString() });
});

app.Run();
