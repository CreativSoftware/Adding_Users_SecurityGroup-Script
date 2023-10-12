
$userlist =  Import-Excel -Path .\IG_DIG.xlsx | Select-Object "Employee Name"

$domain_username = Read-Host -Prompt "Enter YOUR ADMIN domain\username"
$credientials = Get-Credential -UserName $domain_username -Message 'Enter Admin Password'

foreach ($nameEntry in $userlist) {
    $name = $nameEntry."Employee Name"
    $last, $first = $name -split ","
    
    if ($first) {
        $first = $first.Trim()
    }
    if ($last) {
        $last = $last.Trim()
    }

    $newName = "$first $last"
    $obj = New-Object psobject -Property @{
        'FullName' = $newName
    }

    $employeenames = $obj.FullName
    $users = Get-ADUser -Filter "Name -like '*$employeenames'" -Properties * | Select-Object Name, SamAccountName
    Add-ADGroupMember -Identity IG-Email-Search -Members $users.SamAccountName -Credential $credientials
}
