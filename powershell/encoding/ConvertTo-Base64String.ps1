[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$Text
)

process {
  $bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
  return [System.Convert]::ToBase64String($bytes)
}