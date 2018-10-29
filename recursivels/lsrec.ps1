$path="C:\train\20.01"
cls
icacls "$path" /reset /T
 & icacls "$path" /grant:r "pirbank\vshilin:F" /T
 & icacls "$path" /grant:r "pirbank\ddorkin:F" /T
Get-ChildItem -Recurse $path | % {
    if (!$_.PsIsContainer){
        $filename=$_.Fullname
        & icacls "$filename" /grant:r "pirbank\vshilin:F" /T
        & icacls "$filename" /grant:r "pirbank\ddorkin:F" /T
    }
}
echo ""
Get-ChildItem -Recurse $path | % {
    if ($_.PsIsContainer){
        $filename=$_.Fullname
        & icacls "$filename" /grant:r "pirbank\vshilin:F" /T
        & icacls "$filename" /grant:r "pirbank\ddorkin:F" /T
    }
}

& icacls "$path" /inheritance:r /T