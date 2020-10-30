[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [string]$Base64String
)

process {
  return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64String))
}