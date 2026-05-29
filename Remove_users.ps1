$GroupName = "Group_name"

$Members = Get-ADGroupMember -Identity $GroupName

Remove-ADGroupMember `
    -Identity $GroupName `
    -Members $Members `
    -Confirm:$false