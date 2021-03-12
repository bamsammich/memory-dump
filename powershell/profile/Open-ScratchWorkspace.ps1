[CmdletBinding()]
param (
  [Parameter()]
  [System.IO.DirectoryInfo]$ScratchDir = "$env:USERPROFILE/Documents/scratch"
)
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAp {
      [DllImport("user32.dll")]
      [return: MarshalAs(UnmanagedType.Bool)]
      public static extern bool SetForegroundWindow(IntPtr hWnd);

      [DllImport("user32.dll")]
      [return: MarshalAs(UnmanagedType.Bool)]
      public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    }
"@

if (-not (Get-Command code)) {
  throw "Command `"code`" not found. Assuming VS Code isn't installed."
}

if (-not (Get-Variable -Name VS_SCRATCH_PROC -Scope Global -ErrorAction Ignore)) {
  New-Variable -Name VS_SCRATCH_PROC -Scope Global
}
if ($GLOBAL:VS_SCRATCH_PROC | Get-Process -ErrorAction Ignore) {
  $handle = $GLOBAL:VS_SCRATCH_PROC.MainWindowHandle
  [void] [WinAp]::SetForegroundWindow($handle)
}
if (-not (Test-Path $ScratchDir)) {
  New-Item -Path $ScratchDir -ItemType Directory -Force -ErrorAction Stop
}

$GLOBAL:VS_SCRATCH_PROC = Start-Process code -ArgumentList "$ScratchDir -n" -WindowStyle Hidden