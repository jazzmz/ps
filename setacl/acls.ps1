$path = "C:\test\setacl\test"

Function setacl()
{
$acl = Get-Acl $path\$_
echo $acl.Owner
$ID = new-object System.Security.Principal.NTAccount("PIRBANK", "admin_dorkin")
# echo $ID

$p = Get-Privilege $ID
$p.Enable('SeTakeOwnershipPrivilege')
Set-Privilege $p

$acl.SetOwner($ID)
set-acl -path $path\$_ -aclObject $acl
}



get-childitem -recurse $path |% { setacl }

