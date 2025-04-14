# Obsidian-Sync.ps1 - Sync script for Obsidian users
# This script will set up and sync your Obsidian vault with the KSBC GitHub repository

# Configuration
$Host.UI.RawUI.WindowTitle = "KSBC Content Sync"
$MainBranch = "main" # Change if your default branch is different
$RepoUrl = "https://github.com/ks-sbc/website-content.git" # UPDATE THIS WITH YOUR ACTUAL REPOSITORY URL
$ObsidianFolderName = "ksbc-obsidian"

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

function Check-GitInstalled {
    try {
        git --version | Out-Null
        return $true
    }
    catch {
        Write-ColorOutput Red "❌ Error: Git not found. Please install Git for Windows."
        Write-ColorOutput Yellow "Download from: https://git-scm.com/download/win"
        return $false
    }
}

function Check-GitHubCredentials {
    Write-ColorOutput Cyan "Checking GitHub credentials..."
    
    # Test authentication by attempting a simple git operation
    $output = git ls-remote --quiet $RepoUrl 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "✓ GitHub credentials verified!"
        return $true
    }
    else {
        Write-ColorOutput Yellow "GitHub credentials not found or invalid."
        Write-ColorOutput Yellow "Setting up Git credentials..."
        
        # Configure Git to use Git Credential Manager
        git config --global credential.helper manager-core
        
        # This will trigger the credential prompt from Git Credential Manager
        Write-ColorOutput Yellow "You'll be prompted to authenticate with GitHub..."
        $output = git ls-remote --quiet $RepoUrl 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput Green "✓ GitHub credentials set up successfully!"
            return $true
        }
        else {
            Write-ColorOutput Red "❌ Failed to authenticate with GitHub. Please check your credentials."
            return $false
        }
    }
}

function Initialize-Repository {
    # Get My Documents path
    $myDocuments = [Environment]::GetFolderPath("MyDocuments")
    $obsidianPath = Join-Path -Path $myDocuments -ChildPath $ObsidianFolderName
    
    Write-ColorOutput Cyan "Setting up Obsidian repository in $obsidianPath"
    
    # Create the directory if it doesn't exist
    if (-not (Test-Path $obsidianPath)) {
        Write-Output "Creating directory $obsidianPath..."
        New-Item -ItemType Directory -Path $obsidianPath | Out-Null
    }
    
    # Check if it's already a git repository
    if (Test-Path (Join-Path -Path $obsidianPath -ChildPath ".git")) {
        Write-ColorOutput Green "✓ Repository already exists at $obsidianPath"
    }
    else {
        # Clone the repository
        Write-Output "Cloning repository from $RepoUrl to $obsidianPath..."
        Set-Location $myDocuments
        git clone $RepoUrl $ObsidianFolderName
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput Red "❌ Failed to clone repository."
            return $false
        }
        else {
            Write-ColorOutput Green "✓ Repository cloned successfully!"
        }
    }
    
    # Set location to the repository
    Set-Location $obsidianPath
    return $true
}

function Sync-Repository {
    param (
        [string]$RepoPath,
        [string]$RepoName
    )
    
    Write-ColorOutput Green ">>> Syncing $RepoName..."
    
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
    Write-ColorOutput Cyan "This tool will set up and sync your Obsidian vault with the KSBC GitHub repository."
    Write-Output ""
    
    # Check for git installation
    if (-not (Check-GitInstalled)) {
        exit 1
    }
    
    # Check GitHub credentials
    if (-not (Check-GitHubCredentials)) {
        exit 1
    }
    
    # Initialize repository
    if (-not (Initialize-Repository)) {
        exit 1
    }
    
    # Remember our starting position
    $contentRoot = Get-Location
    
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
    Write-Output "===== Sync Summary ====="
    if ($cadresChanges -or $membersChanges -or $contentChanges) {
        Write-ColorOutput Green "✓ Changes synchronized successfully!"
    }
    else {
        Write-ColorOutput Cyan "✓ Everything is up to date. No changes to sync."
    }
    
    Write-Output "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
catch {
    Write-ColorOutput Red "❌ An error occurred during sync:"
    Write-ColorOutput Red $_.Exception.Message
    Write-Output "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
finally {
    # Always return to where we started
    Set-Location $contentRoot
}