[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [System.IO.DirectoryInfo]
  $Directory,
  [Parameter(Mandatory)]
  [ValidatePattern('^\w+$')]
  [string]
  $Username,
  [Parameter(Mandatory)]
  [ArgumentCompleter( {
      [system.enum]::getnames([System.Security.AccessControl.FileSystemRights])
    })]
  [System.Security.AccessControl.FileSystemRights]
  $AccessRights,
  [Parameter()]
  [ArgumentCompleter( {
      [system.enum]::getnames([System.Security.AccessControl.AccessControlType])
    })]
  [System.Security.AccessControl.AccessControlType]
  $AccessType = [System.Security.AccessControl.AccessControlType]::Allow
)
$FullUsername = $Username

if ((Get-LocalUser).Name -notcontains $Username) {
  $FullUsername = "$($env:USERDOMAIN)\$Username"
}

$DirBeginACL = Get-Acl -Path $Directory
try {
  $NewAR = New-Object System.Security.AccessControl.FileSystemAccessRule($FullUsername, $AccessRights, $AccessType)
}
catch {
  throw "Failed to create new access rule: $_"
}
$DirNewACL = Get-Acl -Path $Directory
$DirNewACL.AddAccessRule($NewAR)

$CompareACLs = Compare-Object @($DirNewACL.Access) @($DirBeginACL.Access) -IncludeEqual
if (($CompareACLs | Where-Object { $_.SideIndicator -eq "==" }).Count -ne $DirBeginACL.Access.Count) {
  throw "New ACL did not preserve original permissions. Aborting update, no changes were made."
}

Set-Acl -Path $Directory -AclObject $DirNewACL