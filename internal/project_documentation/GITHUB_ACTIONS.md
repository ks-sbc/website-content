# KSBC GitHub Actions Workflow Strategy

## Overview

This document outlines the GitHub Actions automation strategy for the KSBC website ecosystem. Our CI/CD approach is designed to work harmoniously with our multi-repository structure and branching strategy, providing automated testing, preview deployments, and production releases.

## GitHub Actions Workflow Structure

We'll implement multiple workflows to handle different aspects of our development and deployment processes:

```
.github/workflows/
├── build-test.yml           # Tests builds on all PRs and pushes
├── deploy-staging.yml       # Deploys to staging environment
├── deploy-production.yml    # Deploys to production
└── submodule-update.yml     # Handles submodule updates
```

## Key Workflows

### 1. Build & Test Workflow

**File:** `.github/workflows/build-test.yml`

**Triggers:**
- Pull requests to any branch
- Pushes to `main`, `staging`, and `feature/*` branches

**Actions:**
- Install Node.js and dependencies
- Run Quartz build process
- Verify build completes successfully
- Run any tests we implement

**Example Implementation:**

```yaml
name: Build and Test

on:
  push:
    branches: [main, staging, 'feature/**']
  pull_request:
    branches: [main, staging]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
          
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build website
        run: npx quartz build
        
      # Add test steps as they are developed
```

### 2. Staging Deployment Workflow

**File:** `.github/workflows/deploy-staging.yml`

**Triggers:**
- Pushes to `staging` branch
- Manual trigger (for testing)

**Actions:**
- Build the website
- Deploy to staging environment (e.g., Netlify/Vercel preview)
- Comment on related PR with deployment URL

**Example Implementation:**

```yaml
name: Deploy to Staging

on:
  push:
    branches: [staging]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
          
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build website
        run: npx quartz build
        
      - name: Deploy to staging
        uses: netlify/actions/cli@master
        with:
          args: deploy --dir=public --prod
        env:
          NETLIFY_SITE_ID: ${{ secrets.STAGING_NETLIFY_SITE_ID }}
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
```

### 3. Production Deployment Workflow

**File:** `.github/workflows/deploy-production.yml`

**Triggers:**
- Pushes to `main` branch
- Manual trigger with approval

**Actions:**
- Build the website with production settings
- Deploy to production environment
- Create deployment tag

**Example Implementation:**

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Requires approval
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
          
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build website
        run: npx quartz build
        
      - name: Deploy to production
        uses: netlify/actions/cli@master
        with:
          args: deploy --dir=public --prod
        env:
          NETLIFY_SITE_ID: ${{ secrets.PRODUCTION_NETLIFY_SITE_ID }}
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          
      - name: Create deployment tag
        run: |
          git tag deploy-$(date '+%Y%m%d%H%M%S')
          git push origin --tags
```

### 4. Submodule Update Workflow

**File:** `.github/workflows/submodule-update.yml`

**Triggers:**
- Scheduled runs (daily)
- Manual trigger

**Actions:**
- Check for submodule updates
- Create PRs for any updated submodules
- Run build tests on the updates

**Example Implementation:**

```yaml
name: Update Submodules

on:
  schedule:
    - cron: '0 0 * * *'  # Run daily at midnight
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
          
      - name: Update submodules
        run: |
          git submodule update --remote
          
      - name: Check for changes
        id: check_changes
        run: |
          if [[ -n $(git status --porcelain) ]]; then
            echo "has_changes=true" >> $GITHUB_OUTPUT
          else
            echo "has_changes=false" >> $GITHUB_OUTPUT
          fi
          
      - name: Create Pull Request
        if: steps.check_changes.outputs.has_changes == 'true'
        uses: peter-evans/create-pull-request@v5
        with:
          title: 'chore: update submodules'
          branch: 'auto-update-submodules'
          base: 'staging'
          commit-message: 'chore: update submodules to latest version'
```

## Implementation Strategy

### 1. Initial Setup

1. **Create `.github/workflows` directory** in each repository:
   ```bash
   mkdir -p .github/workflows
   ```

2. **Add workflow files** based on the examples above, tailored to your specific needs.

3. **Configure necessary secrets** in GitHub repository settings:
   - `NETLIFY_AUTH_TOKEN` or equivalent hosting provider credentials
   - `STAGING_NETLIFY_SITE_ID` for staging site
   - `PRODUCTION_NETLIFY_SITE_ID` for production site
   - Any other needed tokens or credentials

### 2. Workflow Enhancements

Consider adding these features to your workflows:

1. **Caching:**
   - Cache npm dependencies
   - Cache Quartz build artifacts if appropriate

2. **Notifications:**
   - Slack/Discord notifications on deployment
   - Email alerts for failed builds

3. **Additional Testing:**
   - Linting
   - Link checking
   - Accessibility testing

### 3. Multi-Repo Coordination

Since our content is in separate repositories linked as submodules, we need special handling:

1. **Webhook Triggers:**
   - Set up webhooks in submodule repositories to trigger builds in the main repository when content changes

2. **Submodule Sync Automation:**
   - Automate the process of updating submodule references in the parent repository
   - Consider using a GitHub Action to create PRs when submodule content changes

## Specific Considerations for Our Setup

### For Tiered Access Control

Our multi-tiered security model requires careful handling in CI/CD:

1. **Repository Secrets:**
   - Keep separate secrets for each repository
   - Use environment-specific secrets for staging vs. production

2. **Protected Branches:**
   - Configure GitHub environments with required reviewers for production deployments
   - Ensure staging deployments can only be triggered by authorized users

### For Quartz-Specific Configuration

Quartz requires some specific handling in our workflows:

1. **Full Submodule Checkout:**
   - Ensure workflows check out all submodules recursively
   - Handle potential authentication issues for private submodules

2. **Quartz Sync Command:**
   - Integrate the `npx quartz sync` command where appropriate
   - Handle content syncing and building in a single workflow

### Example Workflow for Quartz Sync

```yaml
name: Quartz Sync and Deploy

on:
  workflow_dispatch:
  push:
    branches: [main]
    paths:
      - 'content/**'

jobs:
  sync-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive
          token: ${{ secrets.REPO_ACCESS_TOKEN }}
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'
          
      - name: Install dependencies
        run: npm ci
      
      - name: Sync content
        run: npx quartz sync --message "Automated content sync $(date '+%Y-%m-%d %H:%M')"
        
      - name: Build site
        run: npx quartz build
      
      - name: Deploy
        # Deployment steps here
```

## Update to Windows PowerShell Scripts

To help Windows users who rely on our PowerShell scripts, we should update them to trigger GitHub Actions workflows manually:

```powershell
# Add to Obsidian-Sync.ps1
$triggerBuild = Read-Host "Would you like to trigger a website rebuild? (y/n)"
if ($triggerBuild -eq "y") {
    Write-ColorOutput Green "Triggering website rebuild..."
    # Use GitHub API to trigger workflow_dispatch event
    # This requires a personal access token with workflow permissions
}
```

## Conclusion

These GitHub Actions workflows will automate our development and deployment processes while respecting our complex repository structure and security model. By implementing these workflows, we can ensure consistent builds, reliable deployments, and reduce manual overhead for content and code changes.

For questions or configuration issues, please contact the KSBC webmaster. 