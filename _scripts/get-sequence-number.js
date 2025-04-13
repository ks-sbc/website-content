function getSequenceNumberUtility(tp) {
    // Define mapping tables
    const roleMappings = {
        'Development': 'DEV',
        'External': 'EXT',
        'Internal': 'INT'
    };
    
    const typeMappings = {
        'Standard Operating Procedure': 'SOP',
        'Minutes': 'MIN',
        'Training': 'TRN',
        'Doctrine': 'DCT',
        'Guide': 'GDE',
        'Reference': 'REF',
        'Curriculum': 'CUR',
        'Development Journal': 'JRN',
        'Statement': 'STM',
        'Report': 'RPT',
        'Policy': 'PCY',
        'Lesson Plan': 'LPN',
        'Glossary': 'GLS'
    };
    
    const securityMappings = {
        'Public': 'L0',
        'Candidate': 'L1',
        'Cadre': 'L2',
        'Limited Release': 'L3R'
    };

    /**
     * Gets document codes from provided parameters
     */
    function getDocumentCodes(role, type, securityLevel) {
        return {
            role: roleMappings[role] || 'UNK',
            type: typeMappings[type] || 'UNK',
            security: securityMappings[securityLevel] || 'L0'
        };
    }

    /**
     * Gets the highest sequence number for documents with specified codes
     */
    async function getHighestSequenceNumber(role, type, securityLevel) {
        const files = tp.app.vault.getMarkdownFiles();
        
        // Get document codes
        const docCodes = getDocumentCodes(role, type, securityLevel);
        const roleCode = docCodes.role;
        const typeCode = docCodes.type;
        const securityCode = docCodes.security;
        
        let highestSeq = 0;
        
        // Create dynamic regex pattern
        const pattern = new RegExp(`${roleCode}-${typeCode}-\\d{4}-(\\d{3})-${securityCode}`);
        
        for (const file of files) {
            const metadata = tp.app.metadataCache.getFileCache(file)?.frontmatter;
            
            if (!metadata || !metadata.document_id) continue;
            
            const match = metadata.document_id.match(pattern);
            if (match && match[1]) {
                const seqNum = parseInt(match[1], 10);
                if (!isNaN(seqNum) && seqNum > highestSeq) {
                    highestSeq = seqNum;
                }
            }
        }
        return highestSeq;
    }

    return {
        getDocumentCodes,
        getHighestSequenceNumber,
        mappings: {
            role: roleMappings,
            type: typeMappings,
            security: securityMappings
        }
    };
}

module.exports = getSequenceNumberUtility;
