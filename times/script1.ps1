$dir="C:\test\"

Get-ChildItem -Recurse "C:\" | % {$name=$_.Fullname; $fulltime=$_.LastWriteTime; $time=$_.LastWriteTime -split " "; $time=$time[1]; $time=$time.Substring(0,2); if ($time -ge 17){ echo "$name $fulltime" }}