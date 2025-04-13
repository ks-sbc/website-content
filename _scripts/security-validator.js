// Security Level Validator
async function validateSecurityLevel(tp) {
  const currentLevel = tp.frontmatter.security_classification;
  const path = tp.file.path;
  
  // Security level mapping to directory paths
  const securityPaths = {
    'Public': ['public/'],
    'Member': ['member/', 'public/'],
    'Internal': ['internal/', 'member/', 'public/'],
    'Restricted': ['restricted/', 'internal/', 'member/', 'public/']
  };
  
  // Check if file is in allowed directory
  const allowedPaths = securityPaths[currentLevel];
  const isValidPath = allowedPaths.some(dir => path.startsWith(dir));
  
  if (!isValidPath) {
    const correctPath = allowedPaths[0] + path;
    await tp.file.move(correctPath);
    return `Moved file to correct security path: ${correctPath}`;
  }
  return 'Security level and path match';
}

module.exports = validateSecurityLevel;
