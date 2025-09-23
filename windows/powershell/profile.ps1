Invoke-Expression (& 'C:\Program Files\starship\bin\starship.exe' init powershell --print-full-init | Out-String)

function ghqfzf {
    $repo = $(ghq list | fzf)
    Set-Location ( Join-Path $(ghq root) $repo)
}

Set-PSReadLineKeyHandler -Chord Ctrl+] -ScriptBlock {
    ghqfzf
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

Import-Module Abbr

ealias g 'git'

ealias 'git a' 'git add'
ealias 'git b' 'git branch'
ealias 'git c' 'git commit -m'
ealias 'git f' 'git fetch'
ealias 'git fetch p' 'git fetch --prune'
ealias 'git h' 'git push'
ealias 'git p' 'git pull'
ealias 'git s' 'git status'
ealias 'git switch c' 'git switch -c'
ealias 'git w' 'git switch'

ealias 'gh p' 'gh pr'
ealias 'gh pr c' 'gh pr create'
ealias 'gh pr m' 'gh pr merge'