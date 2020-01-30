
[CmdletBinding()]
param(
  [Parameter(Mandatory,
    HelpMessage = "Size in bytes",
    ValueFromPipeline)]
  [ValidateScript( { $_ -ge 0 })]
  [Int64]$Size,
  [Parameter()]
  [ValidateSet('BINARY', 'DECIMAL')]
  [string]$UnitType = 'BINARY',
  [Parameter()]
  [ValidateSet('B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB')]
  [string]$OutputUnit
)

begin {
  $unit_map = [ordered]@{
    'B'  = 0;
    'KB' = 1;
    'MB' = 2;
    'GB' = 3;
    'TB' = 4;
    'PB' = 5;
    'EB' = 6;
  }
}

process {
  switch ($UnitType) {
    'BINARY' { $base = 1024 }
    'DECIMAL' { $base = 1000 }
  }

  if ($OutputUnit) {
    return "$($Size/[System.Math]::Pow($base,$unit_map[$OutputUnit])) $OutputUnit"
  }

  for ($i = 0; $i -lt $unit_map.Count; $i++) {
    if ($Size -gt ([System.Math]::Pow($base, $unit_map[$i]))) {
      continue
    }
    return "$($Size/[System.Math]::Pow($base,$unit_map[$i - 1])) $(($unit_map.Keys -split '`n')[$i - 1])"
  }
}
