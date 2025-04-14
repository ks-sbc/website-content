# KSBC Repository Branching Strategy

## Overview

This document outlines the branching strategy for the KSBC website and content repositories. Our multi-repository structure with Git submodules requires a carefully coordinated branching approach that respects our security tiers while enabling smooth collaboration.

## Branch Structure

### Main Quartz Website Repository (`ksbc-website`)

```
ksbc-website/
├── main                      # Production branch, website is built from here
├── staging                   # Pre-production review branch for the Webmaster
├── feature/project-management    # Technical feature branch
└── feature/*                 # Other technical feature branches as needed
```

### Content Repository (submodule: `website-content`)

```
website-content/
├── main                      # Stable content, synced with main website
├── staging                   # Content ready for review
├── content/minutes           # Branch for developing meeting minutes
└── content/lessons           # Branch for creating educational materials
```

### Cadres Repository (submodule: `internal/cadres`)

```
cadre-repo/
├── main                      # Stable cadre content
├── staging                   # Review branch for cadre materials
└── content/*                 # Topical branches for cadre-specific work
```

### Members Repository (submodule: `internal/members`)

```
member-repo/
├── main                      # Stable member content
├── staging                   # Review branch for member materials
└── content/*                 # Topical branches for member-specific materials
```

## Workflow Processes

### Content Development Workflow

1. **Start in the appropriate repository:**
   - Public content: Work in `website-content` repository
   - Member content: Work in `member-repo` repository
   - Cadre content: Work in `cadre-repo` repository

2. **Create or switch to content branch:**
   ```bash
   # Example for meeting minutes in main content repo
   git checkout -b content/minutes
   ```

3. **Make content changes in Obsidian**

4. **Commit changes to content branch:**
   ```bash
   git add .
   git commit -m "Add January meeting minutes"
   git push origin content/minutes
   ```

5. **Open a Pull Request to staging branch**
   - Create PR from `content/minutes` → `staging`
   - Request review from appropriate team members

6. **Webmaster Review:**
   - Webmaster reviews changes in `staging` branch
   - May request revisions or approve

7. **Merge to main:**
   - After approval, merge `staging` → `main`
   - This keeps the main branch stable with reviewed content

### Feature Development Workflow

1. **Create feature branch in the main repository:**
   ```bash
   # In ksbc-website repository
   git checkout -b feature/project-management
   ```

2. **Implement technical changes:**
   - Update Quartz configuration
   - Modify styling or layouts
   - Add new functionality

3. **Test locally:**
   ```bash
   npx quartz build --serve
   ```

4. **Commit and push changes:**
   ```bash
   git add .
   git commit -m "Add project management features"
   git push origin feature/project-management
   ```

5. **Open Pull Request to staging:**
   - Create PR from `feature/project-management` → `staging`

6. **Review, test, and merge:**
   - Review code changes
   - Test in staging environment
   - Merge to `staging` first, then to `main` after final approval

## Submodule Management

The complexity of this setup comes from managing the submodule references. Here's how to handle them:

### Updating Submodule References

When content changes are made in any submodule:

1. **Commit and push changes in the submodule repository**
2. **Update the parent repository to point to the new commit:**
   ```bash
   # In parent repository (e.g., ksbc-website or website-content)
   git add path/to/submodule
   git commit -m "Update submodule reference to latest version"
   git push
   ```

### Handling Branch Changes in Submodules

When switching branches in a submodule:

1. **Checkout the desired branch in the submodule:**
   ```bash
   cd content/internal/members
   git checkout staging
   ```

2. **Update the parent repository to track this change:**
   ```bash
   cd ../../..  # Back to parent repo
   git add content/internal/members
   git commit -m "Point members submodule to staging branch"
   ```

## Implementation Plan

### 1. Initial Branch Setup

```bash
# In the main website repo
git checkout -b staging
git push origin staging

git checkout -b feature/project-management
git push origin feature/project-management

# In the content repo
cd content
git checkout -b staging
git push origin staging

git checkout -b content/minutes
git push origin content/minutes

git checkout -b content/lessons
git push origin content/lessons

# Repeat similar process for cadres and members submodules
```

### 2. GitHub Repository Configuration

1. **Protected Branches:**
   - Set `main` as a protected branch in all repositories
   - Require pull request reviews before merging to `main`
   - Require status checks to pass before merging

2. **Branch Protection Rules:**
   - Prevent force pushes to `main` and `staging`
   - Restrict who can push to protected branches

3. **Default Branch:**
   - Set `main` as the default branch

### 3. CI/CD Configuration

1. **GitHub Actions for `ksbc-website` repository:**
   - Test build on any PR to `staging` or `main`
   - Automatically deploy to staging environment when changes are merged to `staging`
   - Deploy to production when changes are merged to `main`

2. **Automated Submodule Updates:**
   - Consider setting up automation to detect submodule changes and create PRs

## Special Considerations for Our Setup

### For Obsidian Users

Most contributors will use Obsidian and may not understand Git branches. Consider:
- Adding branch information to our PowerShell scripts
- Creating simplified instructions for non-technical users to switch branches
- Adding visual indicators in Obsidian to show which branch is active

### Handling Submodule Permissions

Some contributors may only have access to specific submodules:
- Document how permissions work with different branches
- Create branch-specific setup scripts if needed

### Simplified Contribution for Windows Users

Update our existing PowerShell scripts to support branch switching:
```powershell
# Add to Obsidian-Sync.ps1
$branch = Read-Host "Which branch to work with? (main, staging, content/minutes)"
git checkout $branch
```

## Branch Naming Conventions

To maintain consistency, follow these naming conventions:

- `main`: Production-ready content and code
- `staging`: Content and code ready for review
- `content/[type]`: Content-focused branches (e.g., `content/minutes`, `content/lessons`)
- `feature/[name]`: Technical feature branches (e.g., `feature/project-management`)
- `hotfix/[issue]`: Emergency fixes for production issues

## Conclusion

This branching strategy provides structure for our multi-repository setup while maintaining the security model we've established. It enables content creators to work effectively while providing the webmaster with proper review capabilities before publishing.

For questions or clarification, contact the KSBC webmaster.

