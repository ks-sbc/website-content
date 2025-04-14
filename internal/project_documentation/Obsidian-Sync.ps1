# Obsidian-Sync.ps1 - Sync script for Obsidian users
# Save this file in your content folder (Obsidian vault)

# Text formatting
$Host.UI.RawUI.WindowTitle = "KSBC Content Sync"
$MainBranch = "main" # Change if your default branch is different

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Sync-Repository {
    param (
        [string]$RepoPath,
        [string]$RepoName
    )
    
    Write-ColorOutput Green "`n>>> Syncing $RepoName..."
    
    Push-Location $RepoPath
    
    # Check if we're in detached HEAD state
    $headRef = git symbolic-ref -q HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput Yellow "⚠️ Detached HEAD state detected. Checking out $MainBranch branch..."
        git checkout $MainBranch
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput Yellow "⚠️ Couldn't check out $MainBranch, determining default branch..."
            $defaultBranch = (git remote show origin | Select-String "HEAD branch").ToString().Split(":")[1].Trim()
            Write-ColorOutput Yellow "Detected default branch: $defaultBranch"
            git checkout $defaultBranch
        }
    }
    else {
        Write-Output "✓ Already on a branch"
    }
    
    # Pull latest changes
    Write-Output "Pulling latest changes..."
    $currentBranch = (git branch --show-current)
    git pull origin $currentBranch
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput Yellow "⚠️ Pull failed, continuing with local changes"
    }
    
    # Check for changes
    $hasChanges = $false
    $status = git status --porcelain
    if ($status) {
        $hasChanges = $true
        Write-Output "Changes detected, committing..."
        git add .
        git commit -m "Update $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        if ($LASTEXITCODE -ne 0) {
            Write-Output "No changes to commit"
        }
        else {
            git push origin $currentBranch
            if ($LASTEXITCODE -ne 0) {
                Write-ColorOutput Yellow "⚠️ Push failed. Changes committed locally but not pushed to remote."
                Write-ColorOutput Yellow "   Please contact the repository administrator for assistance."
            }
            else {
                Write-ColorOutput Green "✓ Changes pushed successfully!"
            }
        }
    }
    else {
        Write-Output "No changes detected"
    }
    
    Pop-Location
    return $hasChanges
}

try {
    Clear-Host
    Write-ColorOutput Cyan "===== KSBC Obsidian Content Sync Tool ====="
    Write-ColorOutput Cyan "This tool will sync your Obsidian changes to the KSBC website."
    Write-Output ""
    
    # Remember our starting position
    $contentRoot = Get-Location
    
    # Check that we're in the content folder
    if (-not (Test-Path ".git")) {
        Write-ColorOutput Red "❌ Error: Not in a git repository. Please run this script from your Obsidian vault folder."
        exit 1
    }
    
    # Check for git
    try {
        git --version | Out-Null
    }
    catch {
        Write-ColorOutput Red "❌ Error: Git not found. Please install Git for Windows."
        Write-ColorOutput Yellow "Download from: https://git-scm.com/download/win"
        exit 1
    }
    
    # 1. First check and sync the cadres submodule if it exists
    $cadresChanges = $false
    if (Test-Path "internal/cadres") {
        $cadresChanges = Sync-Repository -RepoPath "internal/cadres" -RepoName "cadres submodule"
    }
    
    # 2. Check and sync the members submodule if it exists
    $membersChanges = $false
    if (Test-Path "internal/members") {
        $membersChanges = Sync-Repository -RepoPath "internal/members" -RepoName "members submodule"
    }
    
    # 3. Sync the main content repository
    Set-Location $contentRoot
    $contentChanges = Sync-Repository -RepoPath "." -RepoName "content repository"
    
    # Summary
    Write-Output "`n===== Sync Summary ====="
    if ($cadresChanges -or $membersChanges -or $contentChanges) {
        Write-ColorOutput Green "✓ Changes synchronized successfully!"
    }
    else {
        Write-ColorOutput Cyan "✓ Everything is up to date. No changes to sync."
    }
    
    Write-Output "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
catch {
    Write-ColorOutput Red "❌ An error occurred during sync:"
    Write-ColorOutput Red $_.Exception.Message
    Write-Output "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
finally {
    # Always return to where we started
    Set-Location $contentRoot
}