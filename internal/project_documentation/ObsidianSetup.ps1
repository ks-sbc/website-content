# Obsidian-Setup.ps1 - Initial setup script for KSBC Content repository
# For Windows users who just need the content folder for Obsidian

# Text formatting
$Host.UI.RawUI.WindowTitle = "KSBC Content Setup"
$MainBranch = "main" # Change if your default branch is different
$ContentRepoURL = "https://github.com/ks-sbc/website-content.git" # Update with your content repo URL

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

function CheckCommand {
    param (
        [string]$Command,
        [string]$InstallInstructions
    )
    
    try {
        Invoke-Expression "$Command" | Out-Null
        Write-ColorOutput Green "✓ $Command is installed"
        return $true
    }
    catch {
        Write-ColorOutput Red "❌ $Command is not installed."
        Write-ColorOutput Yellow $InstallInstructions
        return $false
    }
}

function SetupRepository {
    param (
        [string]$RepoPath,
        [string]$RepoName
    )
    
    Write-ColorOutput Green "`n>>> Setting up $RepoName..."
    
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
    
    # Configure git settings
    git config core.autocrlf true
    git config core.fileMode false
    
    Pop-Location
}

try {
    Clear-Host
    Write-ColorOutput Cyan "===== KSBC Obsidian Content Setup Tool ====="
    Write-ColorOutput Cyan "This tool will set up the KSBC content repository for use with Obsidian."
    Write-Output ""
    
    # Check for prerequisites
    Write-Output "Checking prerequisites..."
    $gitInstalled = CheckCommand -Command "git --version" -InstallInstructions "Please install Git for Windows from: https://git-scm.com/download/win"
    if (-not $gitInstalled) {
        Write-ColorOutput Red "Required tool missing. Please install it and run this script again."
        Write-Output "`nPress any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
    
    # Ask for target directory
    Write-Output ""
    $defaultDir = "$env:USERPROFILE\Documents\KSBC-Content"
    $targetDir = Read-Host "Where would you like to set up the repository? (default: $defaultDir)"
    if ([string]::IsNullOrWhiteSpace($targetDir)) {
        $targetDir = $defaultDir
    }
    
    # Create directory if it doesn't exist
    if (-not (Test-Path $targetDir)) {
        Write-Output "Creating directory: $targetDir"
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }
    
    # Clone the content repository
    Write-ColorOutput Green "`n>>> Cloning content repository..."
    Set-Location $targetDir
    git clone $ContentRepoURL .
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput Red "❌ Failed to clone repository. Please check the URL and your internet connection."
        exit 1
    }
    
    # Initialize submodules
    Write-ColorOutput Green "`n>>> Initializing submodules..."
    git submodule init
    git submodule update
    
    # Set up the main content repository
    SetupRepository -RepoPath "." -RepoName "content repository"
    
    # Set up cadres submodule if it exists
    if (Test-Path "internal/cadres") {
        SetupRepository -RepoPath "internal/cadres" -RepoName "cadres submodule"
    }
    
    # Set up members submodule if it exists
    if (Test-Path "internal/members") {
        SetupRepository -RepoPath "internal/members" -RepoName "members submodule"
    }
    
    # Copy the sync script if it exists in the same directory as this setup script
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $syncScriptSource = Join-Path $scriptDir "Obsidian-Sync.ps1"
    if (Test-Path $syncScriptSource) {
        Write-ColorOutput Green "`n>>> Copying sync script..."
        Copy-Item $syncScriptSource -Destination $targetDir
        Write-Output "✓ Sync script copied"
    }
    else {
        # Create a simple sync script if the full one isn't available
        Write-ColorOutput Yellow "`n>>> Creating basic sync script..."
        @"
# Basic sync script for KSBC content
Write-Host "Syncing KSBC content..." -ForegroundColor Cyan
git pull
git add .
git commit -m "Update $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push
Write-Host "Done!" -ForegroundColor Green
pause
"@ | Out-File -FilePath (Join-Path $targetDir "Obsidian-Sync.ps1") -Encoding utf8
        Write-Output "✓ Basic sync script created"
    }
    
    # Create desktop shortcut for the sync script
    Write-ColorOutput Green "`n>>> Creating desktop shortcut for sync script..."
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\KSBC Content Sync.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$targetDir\Obsidian-Sync.ps1`""
    $Shortcut.WorkingDirectory = $targetDir
    $Shortcut.Save()
    Write-Output "✓ Desktop shortcut created"
    
    # Success message and next steps
    Write-ColorOutput Green "`n✅ Setup complete!"
    Write-Output "`nNext steps:"
    Write-Output "1. Open Obsidian"
    Write-Output "2. Click 'Open folder as vault'"
    Write-Output "3. Select this folder: $targetDir"
    Write-Output "`nTo sync your changes later, use the 'KSBC Content Sync' shortcut on your desktop."
    
    Write-Output "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
catch {
    Write-ColorOutput Red "❌ An error occurred during setup:"
    Write-ColorOutput Red $_.Exception.Message
    Write-Output "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}