---
draft: true
---
# KSBC Website Content Repository

This repository serves as the central Obsidian vault for managing all content related to the Kansas Socialist Book Club (KSBC) website. It is structured to support a multi-tiered access model while providing a unified editing experience, primarily through Obsidian.

This repository is integrated as a Git submodule within the main [KSBC Quartz website repository](https://github.com/ks-sbc/ksbc-website.git).

## Editing Content

It is highly recommended to use [Obsidian](https://obsidian.md/) to edit and manage the content within this vault. Obsidian provides a user-friendly interface for creating, linking, and previewing Markdown files.

## Repository Structure

The repository is organized as follows:

*   `/` (Root): Contains public-facing Markdown files (e.g., `index.md`, `about.md`, `bylaws.md`) that are built into the public website by Quartz.
*   `assets/`: Contains images and other static files used in public content.
*   `internal/`: A special directory containing content not intended for the public website build.
    *   `internal/cadres/`: **(Git Submodule)** Restricted content accessible only to Cadre members. Requires separate Git permissions.
    *   `internal/members/`: **(Git Submodule)** Content accessible only to vetted KSBC Members. Requires separate Git permissions.
    *   `internal/project_documentation/`: Contains documentation related to setting up and managing this content system.
    *   `internal/assets/`: *(Git Ignored)* Non-tracked assets for internal use.
    *   `internal/personal/`: *(Git Ignored)* Non-tracked personal notes or drafts within the internal section.
*   `_templates/`: *(Quartz Ignored)* Contains Obsidian templates. Ignored during the Quartz website build process.
*   `_scripts/`: *(Quartz Ignored)* Contains utility scripts. Ignored during the Quartz website build process.
*   `personal/`: *(Git Ignored)* Top-level directory for personal notes, drafts, or content not meant to be tracked in Git.
*   `drafts/`: *(Git Ignored)* Top-level directory for draft content not meant to be tracked in Git.

## Access Control & Submodules

Content visibility is managed through:

1.  **Git Submodules:** The `internal/cadres` and `internal/members` directories are separate Git repositories (submodules). Access to these repositories is controlled via GitHub permissions, ensuring only authorized individuals can clone or view their contents.
2.  **Quartz Configuration:** The main website build process (managed in the parent `ksbc-website` repository) is configured to ignore paths like `internal/`, `_templates/`, and `_scripts/`, preventing them from appearing on the public site.
3.  **`.gitignore`:** Files and directories listed in `.gitignore` (like `personal/`, `drafts/`, `internal/assets/`, `internal/personal/`) are intentionally not tracked by Git.

## Setup for Contributors

### Non-Technical Windows Users

A PowerShell script is available to automate the setup process. See the instructions in:
`internal/project_documentation/ContentRepoSetup.md`

### Technical Users (Git Familiar)

1.  **Clone the main website repository:**
    ```bash
    git clone https://github.com/ks-sbc/ksbc-website.git
    cd ksbc-website
    ```
2.  **Initialize and update submodules:** This command will clone this `content` repository and attempt to clone the nested `cadres` and `members` submodules (if you have access).
    ```bash
    git submodule update --init --recursive
    ```
    *Note: If you lack access to `cadres` or `members`, Git will show an error for those specific submodules, but the rest of the `content` repository will still be cloned correctly.*

## Syncing Changes

1.  **Make Edits:** Use Obsidian or your preferred editor to modify files within this `content` repository or its submodules (`cadres`/`members` if applicable).
2.  **Commit Changes:**
    *   Commit changes within the specific repository where edits were made (e.g., inside `content/`, `content/internal/cadres/`, or `content/internal/members/`).
    ```bash
    cd path/to/relevant/repository # (e.g., content/ or content/internal/cadres/)
    git add .
    git commit -m "Your descriptive commit message"
    git push
    ```
3.  **Update Parent Repository:** Go back to the main `ksbc-website` repository directory. Git will detect that the submodule reference(s) have changed. Commit this update.
    ```bash
    cd ../.. # (Navigate back to ksbc-website root)
    git add content # Or git add content/internal/cadres etc.
    git commit -m "Update content submodule reference"
    git push
    ```
4.  **Website Sync (Optional):** For deploying website changes, the main repository might use a command like `npx quartz sync`. Refer to the main repository's documentation for deployment details.

## Further Information

For details on the overall website architecture, build process, and deployment, please refer to the README and documentation within the main [ksbc-website repository](https://github.com/ks-sbc/ksbc-website.git).