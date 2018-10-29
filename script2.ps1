Get-ChildItem "T:\Operu" | % {if ($_.psiscontainer) {
	$ACL_RO="ACL_T_OPERU_" + $_ + "_RO";
		dsadd group "CN=$ACL_RO, OU=Groups, DC=pirbank, DC=ru" -secgrp yes -scope l -samid $ACL_RO; 
		$newacl = Get-Acl T:\Operu\$_
		$IdRef = New-Object System.Security.Principal.NTAccount(‘PIRBANK\$ACL_RO’)
		$FsRights = [System.Security.AccessControl.FilesystemRights]"ReadAndExecute"
		$NasledFlags = [System.Security.AccessControl.InheritanceFlags](‘ContainerInherit,Objectinherit’)
		$RaspredFlags = [System.Security.AccessControl.PropagationFlags](‘None’)
		$AccessControlType = [System.Security.AccessControl.AccessControlType](‘Allow’)
		$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($IdRef,$FsRights,$NasledFlags,$RaspredFlags,$AccesscontrolType)
		$newacl.AddAccessRule($rule)
		$newacl | Set-Acl T:\Operu\$_
	
	$ACL_RW="ACL_T_OPERU_" +  $_ + "_RW"; 
	dsadd group "CN=$ACL_RW, OU=Groups, DC=pirbank, DC=ru" -secgrp yes -scope l -samid $ACL_RW
		$newacl = Get-Acl T:\Operu\$_
		$IdRef = New-Object System.Security.Principal.NTAccount(‘PIRBANK\$ACL_RW’)
		$FsRights = [System.Security.AccessControl.FilesystemRights]"FullControl"
		$NasledFlags = [System.Security.AccessControl.InheritanceFlags](‘ContainerInherit,Objectinherit’)
		$RaspredFlags = [System.Security.AccessControl.PropagationFlags](‘None’)
		$AccessControlType = [System.Security.AccessControl.AccessControlType](‘Allow’)
		$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($IdRef,$FsRights,$NasledFlags,$RaspredFlags,$AccesscontrolType)
		$newacl.AddAccessRule($rule)
		$newacl | Set-Acl T:\Operu\$_
}}