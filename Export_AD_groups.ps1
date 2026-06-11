Import-Module ActiveDirectory

$Groups = @(
    "R-G-DataRpt-CustomerExperience",
    "R-G-DataRpt-CXEngineering",
    "R-G-DataRpt-Finance",
    "R-G-DataRpt-PII",
    "R-G-DataRpt-SecurityEng",
    "R-G-DataRpt-Tabl-Creator",
    "R-G-DataRpt-Tabl-Explorer",
    "R-G-DataRpt-Tabl-Viewer",
    "R-G-DataRpt-Tabl-Majorel",
    "R-G-DataRpt-Tabl-Sykes"
)

$OutputFolder = "C:\Temp\DataRpt_Group_Exports"

if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder
}

foreach ($Group in $Groups) {

    Write-Host "Processing $Group..." -ForegroundColor Cyan

    try {

        $Members = Get-ADGroupMember -Identity $Group -Recursive

        $Results = foreach ($Member in $Members) {

            if ($Member.objectClass -eq "user") {

                $User = Get-ADUser $Member.SamAccountName -Properties `
                    DisplayName,
                    Mail,
                    UserPrincipalName,
                    Enabled,
                    DistinguishedName

                [PSCustomObject]@{
                    GroupName          = $Group
                    DisplayName        = $User.DisplayName
                    SamAccountName     = $User.SamAccountName
                    UserPrincipalName  = $User.UserPrincipalName
                    Email              = $User.Mail
                    Enabled            = $User.Enabled
                    DistinguishedName  = $User.DistinguishedName
                }
            }
        }

        $SafeGroupName = $Group -replace '[\\/:*?"<>|]', '_'

        $CsvPath = Join-Path $OutputFolder "$SafeGroupName.csv"

        $Results | Export-Csv -Path $CsvPath -NoTypeInformation

        Write-Host "Exported $CsvPath" -ForegroundColor Green
    }

    catch {
        Write-Host "Failed processing $Group" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}