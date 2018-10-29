$log = "E:\acl.log"
Get-Date > $log
& icacls D:\disk_t\Operu\* /save E:\aclfile /T /C >> $log
& icacls O:\Operu\ /restore e:\aclfile /C >> $log
Get-Date >> $log