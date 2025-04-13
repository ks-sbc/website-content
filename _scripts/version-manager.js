// Version Number Manager
async function manageVersion(tp) {
    const currentVersion = tp.frontmatter.version;
    const [major, minor, patch] = currentVersion.split('.').map(Number);
    
    // Check for major changes by comparing with git history
    const gitDiff = await tp.user.executeCommand('git diff HEAD^ HEAD');
    
    if (gitDiff.includes('BREAKING CHANGE')) {
      return `${major + 1}.0.0`;
    } else if (gitDiff.includes('feat:')) {
      return `${major}.${minor + 1}.0`;
    } else {
      return `${major}.${minor}.${patch + 1}`;
    }
}

module.exports = manageVersion;
