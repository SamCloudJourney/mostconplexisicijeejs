// Feeds one input file to one framework parser and reports outcome, time and allocation.
// Use it to triage inputs (hand-written or from a fuzzer) and to compare .NET 10 with .NET 11.
//   parser-harness <kind> <file>
// A documented exception is a normal result. What matters: an unexpected exception type, a hang,
// runaway time or memory relative to input size, or a process crash.
using System.Diagnostics;
using System.Formats.Asn1;
using System.Formats.Tar;
using System.IO.Compression;
using System.Runtime.InteropServices;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using System.Xml;

var kinds = new Dictionary<string, Action<byte[]>>
{
    ["json"] = d => { using var doc = JsonDocument.Parse(d); Walk(doc.RootElement); },
    ["xml"] = d => { using var r = XmlReader.Create(new MemoryStream(d)); while (r.Read()) { } },
    ["asn1"] = d => ReadAsn1(new AsnReader(d, AsnEncodingRules.BER)),
    ["x509"] = d => { using var c = X509CertificateLoader.LoadCertificate(d); _ = c.Subject; _ = c.Extensions.Count; },
    ["zip"] = d =>
    {
        using var z = new ZipArchive(new MemoryStream(d), ZipArchiveMode.Read);
        foreach (var e in z.Entries) { using var s = e.Open(); s.CopyTo(Stream.Null); }
    },
    ["tar"] = d =>
    {
        using var t = new TarReader(new MemoryStream(d));
        while (t.GetNextEntry() is { } e) e.DataStream?.CopyTo(Stream.Null);
    },
    ["uri"] = d => { if (Uri.TryCreate(Encoding.UTF8.GetString(d).Trim(), UriKind.RelativeOrAbsolute, out var u) && u.IsAbsoluteUri) { _ = u.Host; _ = u.AbsolutePath; } },
};

if (args.Length != 2 || !kinds.TryGetValue(args[0], out var run))
{
    Console.Error.WriteLine($"usage: parser-harness <{string.Join('|', kinds.Keys)}> <file>");
    return 2;
}

byte[] data = File.ReadAllBytes(args[1]);
long before = GC.GetTotalAllocatedBytes(true);
var sw = Stopwatch.StartNew();
string outcome;
try { run(data); outcome = "ok"; }
catch (Exception e) { outcome = $"exception {e.GetType().FullName}: {e.Message.Split('\n')[0]}"; }
sw.Stop();
long allocated = GC.GetTotalAllocatedBytes(true) - before;

Console.WriteLine($"runtime   : {RuntimeInformation.FrameworkDescription}");
Console.WriteLine($"kind      : {args[0]}");
Console.WriteLine($"input     : {data.Length} bytes");
Console.WriteLine($"outcome   : {outcome}");
Console.WriteLine($"elapsed   : {sw.Elapsed.TotalMilliseconds:F1} ms");
Console.WriteLine($"allocated : {allocated} bytes ({(data.Length == 0 ? 0 : allocated / data.Length)}x input)");
return 0;

static void Walk(JsonElement e)
{
    if (e.ValueKind == JsonValueKind.Object) foreach (var p in e.EnumerateObject()) Walk(p.Value);
    else if (e.ValueKind == JsonValueKind.Array) foreach (var i in e.EnumerateArray()) Walk(i);
}

static void ReadAsn1(AsnReader reader)
{
    while (reader.HasData)
    {
        Asn1Tag tag = reader.PeekTag();
        if (tag.IsConstructed && (tag.HasSameClassAndValue(Asn1Tag.Sequence) || tag.HasSameClassAndValue(Asn1Tag.SetOf)))
            ReadAsn1(tag.HasSameClassAndValue(Asn1Tag.Sequence) ? reader.ReadSequence() : reader.ReadSetOf());
        else reader.ReadEncodedValue();
    }
}
