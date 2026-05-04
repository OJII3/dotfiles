function z {
    $null = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -eq 0) {
        $repoName = Split-Path (git rev-parse --show-toplevel) -Leaf
        zellij attach -c $repoName
    }
    else {
        zellij
    }
}
