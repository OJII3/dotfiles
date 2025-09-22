Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)

function ghqfzf {
    $repo = $(ghq list | fzf)
    Set-Location ( Join-Path $(ghq root) $repo)
}

Set-PSReadLineKeyHandler -Chord Ctrl+] -ScriptBlock {
    ghqfzf
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}