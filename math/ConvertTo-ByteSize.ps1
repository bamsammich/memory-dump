[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [ValidatePattern('[0-9\.]+\s?[a-zA-Z][iI]?[bB]?')]
  [string]$Size
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
  $rgx_match = ([regex]'([0-9\.]+)\s?([a-zA-Z]i?[bB]?)').Match($Size)
  $OrigSize = [double]$rgx_match.Groups[1].Value
  $Unit = $rgx_match.Groups[2].Value

  if (([char[]]$Unit)[1] -match '[iI]') {
    $base = 1024
  }
  else {
    $base = 1000
  }
  $unit_pow = $unit_map[($unit_map.Keys | Where-Object { ([char[]]$_)[0] -match ([char[]]$Unit)[0] })]
  return ($OrigSize * [System.Math]::Pow($base, $unit_pow))
}
