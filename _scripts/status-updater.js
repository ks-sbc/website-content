// Document Status Updater
async function updateDocumentStatus(tp) {
    const currentStatus = tp.frontmatter.status;
    const lastModified = tp.file.last_modified_date;
    const today = new Date();
    const daysSinceModified = (today - lastModified) / (1000 * 60 * 60 * 24);
    
    // Status progression rules
    const statusFlow = {
      'draft': { next: 'review', days: 7 },
      'review': { next: 'approved', days: 14 },
      'approved': { next: 'review', days: 180 }
    };
    
    const nextState = statusFlow[currentStatus];
    if (nextState && daysSinceModified >= nextState.days) {
      return {
        status: nextState.next,
        status_changed: tp.date.now("YYYY-MM-DD"),
        previous_status: currentStatus
      };
    }
    
    return null;
}

module.exports = updateDocumentStatus;
