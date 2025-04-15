# Obsidian-Setup.ps1 - Initial setup script for KSBC Content repository
# For Windows users who just need the content folder for Obsidian
#
# This script automates the process of cloning the KSBC website content repository
# and setting up the necessary Git configuration for use with Obsidian.
# It handles prerequisite checks, directory creation, repository cloning,
# submodule initialization, and shortcut creation.
#
## IMPORTANT
## 
## Open PowerShell as Administrator.
## Run the command: Get-ExecutionPolicy
## If the output is Restricted, it might be preventing the script from running. You can temporarily change it to RemoteSigned (which allows scripts you've downloaded to run if they are signed by a trusted publisher, and scripts you create yourself to run) using: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Configuration
$MainBranch = "main" # Change this if your default branch is different in the remote repository.
$ContentRepoURL = "https://github.com/ks-sbc/website-content.git" # Update with your content repo URL.  Important!

# Function: CheckCommand
# ----------------------
# Checks if a given command is installed and available in the system's PATH.
#
# Parameters:
#   [string]$Command            - The command to check (e.g., "git --version").
#   [string]$InstallInstructions - Instructions to display if the command is not found.
#
# Returns:
#   [bool]                    - $true if the command is found, $false otherwise.
function CheckCommand {
    param (
        [string]$Command,
        [string]$InstallInstructions
    )
    
    try {
        # Attempt to execute the command and redirect output to null.  This avoids
        # displaying the command's normal output, which we don't need for the check.
        Invoke-Expression "$Command" | Out-Null
        
        # If the command executes without throwing an exception, we assume it's installed.
        Write-Output "$Command is installed"
        return $true
    }
    catch {
        # If an exception is caught, the command was not found or had an error.
        Write-Output "ERROR: $Command is not installed."
        Write-Output $InstallInstructions # Display the provided installation instructions.
        return $false
    }
}

# Function: SetupRepository
# ------------------------
# Configures a Git repository (main or submodule) with necessary settings.
#
# Parameters:
#   [string]$RepoPath - The local path to the repository.
#   [string]$RepoName - A descriptive name for the repository (e.g., "content repository", "cadres submodule").
function SetupRepository {
    param (
        [string]$RepoPath,
        [string]$RepoName
    )
    
    Write-Output ">>> Setting up $RepoName..."
    
    # Push the current location onto the stack and change to the repository's directory.
    # This allows us to easily return to the original location when the function finishes.
    Push-Location $RepoPath
    
    try {
        # Check if we're in detached HEAD state.  This can happen after certain git operations.
        git symbolic-ref -q HEAD > $null #  > $null suppresses normal output; we only care about the exit code.
        if ($LASTEXITCODE -ne 0) {
            Write-Output "WARNING: Detached HEAD state detected. Checking out $MainBranch branch..."
            git checkout $MainBranch # Attempt to switch to the main branch.
            if ($LASTEXITCODE -ne 0) {
                Write-Output "WARNING: Couldn't check out $MainBranch, determining default branch..."
                # If checking out the main branch fails, try to determine the default branch.
                $defaultBranch = (git remote show origin | Select-String "HEAD branch").ToString().Split(":")[1].Trim()
                Write-Output "Detected default branch: $defaultBranch"
                git checkout $defaultBranch #  Switch to the default branch.
                if ($LASTEXITCODE -ne 0)
                {
                    Write-Error "ERROR: Could not checkout branch.  Git command 'git checkout $defaultBranch' failed with exit code: $LASTEXITCODE"
                    exit 1
                }
            }
        }
        else {
            Write-Output "Already on a branch"
        }
        
        # Configure Git settings for cross-platform compatibility.
        git config core.autocrlf true  # Ensure consistent line endings across Windows and other systems.
        git config core.fileMode false # Disable file mode tracking (performance optimization).
        
    }
    finally {
        # Ensure we always return to the original location, even if errors occur.
        Pop-Location
    }
}

# Function: Test-GitSubmodule
# --------------------------
#  Checks if a Git submodule exists at the given path
#
#  Parameters:
#    [string]$SubmodulePath - The path to the submodule (e.g., "internal/cadres")
#
#  Returns:
#    [bool] - $True if the submodule exists, $False otherwise
function Test-GitSubmodule {
    param (
        [string]$SubmodulePath
    )

    $fullPath = Join-Path -Path "." -ChildPath $SubmodulePath # Combine the paths
    $gitPath = Join-Path -Path $fullPath -ChildPath ".git"
    return (Test-Path -Path $gitPath -PathType Container)
}


# Main Script Logic
# ------------------
try {
    Write-Output "===== KSBC Obsidian Content Setup Tool ====="
    Write-Output "This tool will set up the KSBC content repository for use with Obsidian."
    
    # Check for prerequisites
    Write-Output "Checking prerequisites..."
    $gitInstalled = CheckCommand -Command "git --version" -InstallInstructions "Please install Git for Windows from: https://git-scm.com/download/win"
    if (-not $gitInstalled) {
        Write-Output "Required tool missing. Please install it and run this script again."
        Write-Output "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") # Wait for key press before exiting.
        exit 1
    }
    
    # Ask for target directory
    Write-Output ""
    $defaultDir = "$env:USERPROFILE\Documents\KSBC-Content" # Default location in the user's Documents folder.
    $targetDir = Read-Host "Where would you like to set up the repository? (default: $defaultDir)"
    if ([string]::IsNullOrWhiteSpace($targetDir)) {
        $targetDir = $defaultDir # Use the default if the user doesn't enter anything.
    }
    
    # Create directory if it doesn't exist
    if (-not (Test-Path $targetDir)) {
        Write-Output "Creating directory: $targetDir"
        New-Item -ItemType Directory -Path $targetDir | Out-Null #  > $null suppresses output.
    }
    
    # Clone the content repository
    Write-Output ">>> Cloning content repository..."
    Set-Location $targetDir # Change to the target directory.
    
    # Check if directory is empty (excluding hidden files/directories)
    $existingFiles = Get-ChildItem -Path $targetDir -Force | Where-Object { $_.Name -ne '.git' }
    if ($existingFiles.Count -gt 0 -and -not (Test-Path (Join-Path -Path $targetDir -ChildPath ".git"))) {
        Write-Output "WARNING: Target directory is not empty. Please choose an empty directory for the repository."
        Write-Output "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") #  Wait for keypress
        exit 1
    }
    
    # Check if it's already a git repository
    if (Test-Path (Join-Path -Path $targetDir -ChildPath ".git")) {
        Write-Output "Repository already exists at $targetDir"
        git pull  #  Try to update the existing repository.
        if ($LASTEXITCODE -ne 0) {
            Write-Error "ERROR: Git pull failed.  Exiting.  Check network and repository."
            exit 1
        }
    } else {
        git clone $ContentRepoURL . # Clone the repository into the current directory (.).
        if ($LASTEXITCODE -ne 0) {
            Write-Output "ERROR: Failed to clone repository. Please check the URL and your internet connection."
            Write-Output "Git clone command failed with exit code: $LASTEXITCODE" # Include exit code
            exit 1
        }
    }
    
    # Initialize submodules
    Write-Output ">>> Initializing submodules..."
    git submodule init # Initialize the submodules.
    git submodule update #  Update the submodules (fetch and checkout).
    
    # Set up the main content repository
    SetupRepository -RepoPath "." -RepoName "content repository"
    
    # Set up cadres submodule if it exists
    if (Test-GitSubmodule -SubmodulePath "internal/cadres") {
        SetupRepository -RepoPath "internal/cadres" -RepoName "cadres submodule"
    }
    
    # Set up members submodule if it exists
    if (Test-GitSubmodule -SubmodulePath "internal/members") {
        SetupRepository -RepoPath "internal/members" -RepoName "cadres submodule"
    }
    
    # Copy the sync script if it exists in the same directory as this setup script
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition # Get the directory of the current script.
    $syncScriptSource = Join-Path $scriptDir "Obsidian-Sync.ps1"       #  Full path to the sync script.
    if (Test-Path $syncScriptSource) {
        Write-Output ">>> Copying sync script..."
        Copy-Item $syncScriptSource -Destination $targetDir # Copy to the target directory.
        Write-Output "Sync script copied"
    }
    else {
        # Create a basic sync script if the full one isn't available
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
"@ | Out-File -FilePath (Join-Path $targetDir "Obsidian-Sync.ps1") -Encoding utf8 #  Specify UTF-8 encoding.
        Write-Output "Basic sync script created"
    }
    
    # Create desktop shortcut for the sync script
    Write-Output ">>> Creating desktop shortcut for sync script..."
    $WshShell = New-Object -ComObject WScript.Shell # Create a WScript.Shell object.
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\KSBC Content Sync.lnk") #  Path to the shortcut.
    $Shortcut.TargetPath = "powershell.exe" #  Target is PowerShell.
    # Arguments to run the sync script, bypassing execution policy and specifying the file.
    $Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$targetDir\Obsidian-Sync.ps1`""
    $Shortcut.WorkingDirectory = $targetDir # Set the working directory for the shortcut.
    $Shortcut.Save() # Save the shortcut.
    Write-Output "Desktop shortcut created"
    
    # Success message and next steps
    Write-Output "Setup complete!"
    Write-Output "Next steps:"
    Write-Output "1. Open Obsidian"
    Write-Output "2. Click 'Open folder as vault'"
    Write-Output "3. Select this folder: $targetDir"
    Write-Output "To sync your changes later, use the 'KSBC Content Sync' shortcut on your desktop."
    
    Write-Output "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") #  Wait for keypress
    
}
catch {
    # Catch any errors that occur during the script execution.
    Write-Output "ERROR: An error occurred during setup:"
    Write-Output $_.Exception.Message #  Display the error message.
    Write-Output "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") #  Wait for keypress
    exit 1 #  Exit with a non-zero exit code to indicate failure.
}
finally {
    pause # Keep the window open after the script finishes, regardless of success or failure.
}
