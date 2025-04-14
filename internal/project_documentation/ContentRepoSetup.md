# Setup Instructions for Windows Team Members

1. Save the script:

- Save this script as Obsidian-Setup.ps1 to your computer (e.g., on your Desktop)

2. Run the script:

- Right-click on the script file
- Select "Run with PowerShell"
- If prompted about execution policy, select "Yes" to run once

3. Follow the prompts:
- The script will check if you have Git installed
- It will ask where you want to set up the repository (default is in your Documents folder)
- It will handle all the cloning and configuration automatically

# What This Script Does

1) Checks Prerequisites: Verifies Git is installed
2) Clones the Content Repository: Sets up the main content folder
3) Initializes Submodules: Sets up cadres and members submodules
4) Fixes Git Configuration: Sets appropriate settings to avoid common issues
5) Creates a Sync Script: Adds a simple script to sync changes later
6) Creates a Desktop Shortcut: Makes it easy to run the sync script
7) Provides Next Steps: Shows how to open the repository in Obsidian

# User Experience

This script is designed for team members who:

- Are not familiar with Git or command line
- Just need access to the content for editing in Obsidian
- Use Windows as their primary operating system
- Need a simple way to publish their changes

The entire process should take just a few minutes, and team members will end up with:

- A properly configured content repository
- An easy-to-use desktop shortcut for syncing changes
- Clear instructions on how to open the folder in Obsidian
- This streamlined setup ensures all team members can contribute without getting bogged down in technical details.