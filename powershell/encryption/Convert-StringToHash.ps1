[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$String,
  [Parameter()]
  [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512', 'RIPEM160')]
  [string]$HashAlgorithm = 'MD5'
)
$algorithm = [System.Security.Cryptography.HashAlgorithm]::Create($HashAlgorithm)
return ($algorithm.ComputeHash([byte[]][char[]]$String) | ForEach-Object { "{0:x2}" -f $_ }) -join ""