Import-Module ActiveDirectory
# 1. Set the AD group name
$GroupName = "Group_name"

# 2. Set export path
$ExportPath = "C:\Temp\$GroupName-members-before-decommission.csv"

# 3. Export direct user members with useful attributes
Get-ADGroupMember -Identity $GroupName |
Where-Object {$_.objectClass -eq "user"} |
ForEach-Object {
    Get-ADUser -Identity $_.DistinguishedName -Properties DisplayName, Mail, Enabled, Department, Title, Manager, LastLogonDate
} |
Select-Object `
    SamAccountName,
    Name,
    DisplayName,
    Mail,
    Enabled,
    Department,
    Title,
    Manager,
    LastLogonDate,
    DistinguishedName |
Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8

Write-Host "Export complete: $ExportPath"

(Get-ADGroupMember -Identity "Group_name").Count