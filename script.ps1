Get-ChildItem "T:\Operu" | % {if ($_.psiscontainer) {
$ACL_RO="ACL_T_OPERU_" + $_ + "_RO";
echo "dsadd group "CN=$ACL_RO, OU=Groups, DC=pirbank, DC=ru" -secgrp yes -scope l -samid $ACL_RO"; 
$ACL_RW="ACL_T_OPERU_" +  $_ + "_RW"; 
echo "dsadd group "CN=$ACL_RW, OU=Groups, DC=pirbank, DC=ru" -secgrp yes -scope l -samid $ACL_RW"}}
