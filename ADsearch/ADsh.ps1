Clear-Host

$CN = "akraskov"
$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Root = $Domain.GetDirectoryEntry()
$Search = [System.DirectoryServices.DirectorySearcher]$Root
#$Search.Filter = "(objectGUID=$Guid)"
#$Search.Filter = "(sAMAccountName=$CN)"
$Result = $Search.FindAll()
ForEach ($P In $Result) {
  if ( $P.properties.Item("CN") -ne "" ){
    if (( $P.properties.Item("CN").Substring(0,1) -ne "{") -and ($P.properties.Item("mail") -ne "")){ 
        Write-Host $P.properties.Item("mail")
    }
  }
  #Write-Host $P.properties.Item("distinguishedName")
}