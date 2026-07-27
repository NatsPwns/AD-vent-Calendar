$user = Get-ADUser -Identity "elian.briceno" -Properties Enabled

$dn = [string]$user.DistinguishedName
$dc = [string](Get-ADDomainController -Discover -Writable).HostName

Get-ADReplicationAttributeMetadata `
    -Object $dn `
    -Server $dc |
Where-Object AttributeName -eq "userAccountControl" |
Select-Object `
    @{Name="Enabled";Expression={$user.Enabled}},
    AttributeName,
    LastOriginatingChangeTime,
    LastOriginatingChangeDirectoryServerIdentity