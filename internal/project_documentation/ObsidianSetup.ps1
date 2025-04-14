# Obsidian-Setup.ps1 - Initial setup script for KSBC Content repository
# For Windows users who just need the content folder for Obsidian

# Configuration
$MainBranch = "main" # Change if your default branch is different
$ContentRepoURL = "https://github.com/ks-sbc/website-content.git" # Update with your content repo URL


function CheckCommand {
    param (
        [string]$Command,
        [string]$InstallInstructions
    )
    
    try {
        Invoke-Expression "$Command" | Out-Null
        Write-Output "$Command is installed"
        return $true
    }
    catch {
        Write-Output "ERROR: $Command is not installed."
        Write-Output $InstallInstructions
        return $false
    }
}

function SetupRepository {
    param (
        [string]$RepoPath,
        [string]$RepoName
    )
    
    Write-Output ">>> Setting up $RepoName..."
    
    Push-Location $RepoPath
    
    # Check if we're in detached HEAD state
    git symbolic-ref -q HEAD > $null
    if ($LASTEXITCODE -ne 0) {
        Write-Output "WARNING: Detached HEAD state detected. Checking out $MainBranch branch..."
        git checkout $MainBranch
        if ($LASTEXITCODE -ne 0) {
            Write-Output "WARNING: Couldn't check out $MainBranch, determining default branch..."
            $defaultBranch = (git remote show origin | Select-String "HEAD branch").ToString().Split(":")[1].Trim()
            Write-Output "Detected default branch: $defaultBranch"
            git checkout $defaultBranch
        }
    }
    else {
        Write-Output "Already on a branch"
    }
    
    # Configure git settings
    git config core.autocrlf true
    git config core.fileMode false
    
    Pop-Location
}

try {
    Write-Output "===== KSBC Obsidian Content Setup Tool ====="
    Write-Output "This tool will set up the KSBC content repository for use with Obsidian."
    
    # Check for prerequisites
    Write-Output "Checking prerequisites..."
    $gitInstalled = CheckCommand -Command "git --version" -InstallInstructions "Please install Git for Windows from: https://git-scm.com/download/win"
    if (-not $gitInstalled) {
        Write-Output "Required tool missing. Please install it and run this script again."
        Write-Output "Press any key to exit..."
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
    Write-Output ">>> Cloning content repository..."
    Set-Location $targetDir
    
    # Check if directory is empty (excluding hidden files/directories)
    $existingFiles = Get-ChildItem -Path $targetDir -Force | Where-Object { $_.Name -ne '.git' }
    if ($existingFiles.Count -gt 0 -and -not (Test-Path (Join-Path -Path $targetDir -ChildPath ".git"))) {
        Write-Output "WARNING: Target directory is not empty. Please choose an empty directory for the repository."
        Write-Output "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
    
    # Check if it's already a git repository
    if (Test-Path (Join-Path -Path $targetDir -ChildPath ".git")) {
        Write-Output "Repository already exists at $targetDir"
        git pull
    } else {
        git clone $ContentRepoURL .
        if ($LASTEXITCODE -ne 0) {
            Write-Output "ERROR: Failed to clone repository. Please check the URL and your internet connection."
            exit 1
        }
    }
    
    # Initialize submodules
    Write-Output ">>> Initializing submodules..."
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
        Write-Output ">>> Copying sync script..."
        Copy-Item $syncScriptSource -Destination $targetDir
        Write-Output "Sync script copied"
    }
    else {
        # Create a simple sync script if the full one isn't available
        Write-Output ">>> Creating basic sync script..."
        @"
# Basic sync script for KSBC content
Write-Output "Syncing KSBC content..."
git pull
git add .
git commit -m "Update $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push
Write-Output "Done!"
pause
"@ | Out-File -FilePath (Join-Path $targetDir "Obsidian-Sync.ps1") -Encoding utf8
        Write-Output "Basic sync script created"
    }
    
    # Create desktop shortcut for the sync script
    Write-Output ">>> Creating desktop shortcut for sync script..."
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\KSBC Content Sync.lnk")
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$targetDir\Obsidian-Sync.ps1`""
    $Shortcut.WorkingDirectory = $targetDir
    $Shortcut.Save()
    Write-Output "Desktop shortcut created"
    
    # Success message and next steps
    Write-Output "Setup complete!"
    Write-Output "Next steps:"
    Write-Output "1. Open Obsidian"
    Write-Output "2. Click 'Open folder as vault'"
    Write-Output "3. Select this folder: $targetDir"
    Write-Output "To sync your changes later, use the 'KSBC Content Sync' shortcut on your desktop."
    
    Write-Output "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
catch {
    Write-Output "ERROR: An error occurred during setup:"
    Write-Output $_.Exception.Message
    Write-Output "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}