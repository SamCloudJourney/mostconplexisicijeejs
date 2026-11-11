// Sends exact bytes to a LOCAL port and prints the raw response. HTTP client libraries normalise
// requests, so byte-exact testing of a parser needs a raw socket.
//   raw-client <port> --file request.bin
//   raw-client <port> --text "GET / HTTP/1.1\r\nHost: lab\r\n\r\n"
// Loopback only by design: this tool refuses to connect anywhere else.
using System.Net;
using System.Net.Sockets;
using System.Text;

if (args.Length != 3 || !int.TryParse(args[0], out int port) || (args[1] != "--file" && args[1] != "--text"))
{
    Console.Error.WriteLine("usage: raw-client <port> --file <path> | --text <string with \\r \\n \\t \\xHH escapes>");
    return 2;
}

byte[] payload = args[1] == "--file" ? File.ReadAllBytes(args[2]) : Unescape(args[2]);

using var client = new TcpClient();
await client.ConnectAsync(IPAddress.Loopback, port);
var stream = client.GetStream();
await stream.WriteAsync(payload);
client.Client.Shutdown(SocketShutdown.Send);

using var stdout = Console.OpenStandardOutput();
var buffer = new byte[16384];
using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(5));
try
{
    int read;
    while ((read = await stream.ReadAsync(buffer, cts.Token)) > 0)
        stdout.Write(buffer, 0, read);
}
catch (OperationCanceledException) { Console.Error.WriteLine("[raw-client] timed out waiting for close"); }
catch (IOException e) { Console.Error.WriteLine($"[raw-client] connection error: {e.Message}"); }
return 0;

static byte[] Unescape(string s)
{
    var bytes = new List<byte>();
    for (int i = 0; i < s.Length; i++)
    {
        if (s[i] == '\\' && i + 1 < s.Length)
        {
            char n = s[++i];
            if (n == 'r') bytes.Add(13);
            else if (n == 'n') bytes.Add(10);
            else if (n == 't') bytes.Add(9);
            else if (n == '\\') bytes.Add((byte)'\\');
            else if (n == 'x' && i + 2 < s.Length) { bytes.Add(Convert.ToByte(s.Substring(i + 1, 2), 16)); i += 2; }
            else { bytes.Add((byte)'\\'); bytes.AddRange(Encoding.UTF8.GetBytes(n.ToString())); }
        }
        else bytes.AddRange(Encoding.UTF8.GetBytes(s[i].ToString()));
    }
    return bytes.ToArray();
}
