Import-Module ActiveDirectory

$GroupName = "Group_name"

$Users = Import-Csv "C:\Temp\Group_name-members-before-decommission.csv"

foreach ($User in $Users) {
    Add-ADGroupMember -Identity $GroupName -Members $User.SamAccountName
}