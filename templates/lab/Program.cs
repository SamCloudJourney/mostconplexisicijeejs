using System.Runtime.InteropServices;

// Print the exact environment first: MSRC requires the product version you validated against.
Console.WriteLine($"Runtime : {RuntimeInformation.FrameworkDescription}");
Console.WriteLine($"OS      : {RuntimeInformation.OSDescription} ({RuntimeInformation.OSArchitecture})");
Console.WriteLine($"RID     : {RuntimeInformation.RuntimeIdentifier}");
Console.WriteLine();

// --- PoC body goes below. Keep it minimal, automatic, and reliable. ---
