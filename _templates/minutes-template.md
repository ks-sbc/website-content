---
<%*
const secLevel = await tp.system.prompt("Enter security level (Public, Candidate, Cadre)");
const made_by = await tp.system.prompt("Enter the name of the person who took notes");
const chaired_by = await tp.system.prompt("Enter the name of the meeting chairperson");
const minuteType = await tp.system.prompt("Type of minutes? (General, Executive Session, Committee, etc.)");
const madeby_tag = made_by.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
const chairedby_tag = chaired_by.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');

// Import the utility
const getSequenceNumberUtility = tp.user["get-sequence-number"];
const seqUtils = getSequenceNumberUtility(tp);

// Fixed role for minutes
const role = "Internal";
const type = "Minutes";

// Get the highest sequence number by passing values directly
const highestSeq = await seqUtils.getHighestSequenceNumber(role, type, secLevel);
const nextSeqNum = (highestSeq + 1).toString().padStart(3, '0');

// Get document codes by passing parameters
const docCodes = seqUtils.getDocumentCodes(role, type, secLevel);

// Create document ID
const docId = `${docCodes.role}-${docCodes.type}-${tp.date.now('YYYY')}-${nextSeqNum}-${docCodes.security}`;


// Rename the document
await tp.file.rename(`${docId}`);
// Begin frontmatter
-%>
title: "Minutes for <% tp.date.now("YYYY-MM-DD") %> <% minuteType %> Meeting"
role: "Internal"
type: "Minutes"
sequence_number: "<% nextSeqNum %>"
security_classification: "<% secLevel %>"
document_id: "<% docId %>"
note_taker: "<% made_by %>"
meeting_chair: "<% chaired_by %>"
meeting_type: "<% minuteType %>"
start_time: ""
end_time: ""
location: ""
date: <% tp.date.now() %>
lastmod: <% tp.date.now() %>
draft: true
version: "1.0.0"
next_review: <% tp.date.now("YYYY-MM-DD", 180) %>
tags:
   - "security/<% secLevel %>"
   - "role/internal"
   - "type/minutes/<% minuteType %>"
   - "function/meeting/chair/<% chairedby_tag %>"
   - "function/meeting/note_taker/<% madeby_tag %>"
---

# {{meeting_type}} Meeting Minutes - {{date}}

## Meeting Information

**Date:** {{date}}  
**Time:** {{start_time}} - {{end_time}}  
**Location:** {{location}}  
**Meeting Type:** {{meeting_type}}  
**Security Classification:** {{security_classification}}  

### Attendees

**Present:**
%% attendance/name/meeting/type/present %%
- List of attendees with roles

**Excused:**
%% attendance/name/meeting/type/excused %%
- List of excused members

**Absent:**
%% attendance/name/meeting/type/absent %%
- List of absent members

**Guest:**
%% attendance/guest_name/meeting/type/guest %%
%% for tracking non-candidate, non-cadre attendance %%
- List of guests in attendance


## 1. Opening

### 1.1 Call to Order
%%Time meeting was called to order%%
Meeting is called to order by {{chaired_by}} at {{start_time}}

### 1.2 Agenda Review
%% Note any changes to proposed agenda %%

### 1.3 Previous Minutes
%% Status of previous minutes approval %%

## 2. Standing Items

### 2.1 Security Update
%% Brief security status and any new protocols %%

### 2.2 Committee Reports
%% Brief updates from active committees %%

## 3. Main Agenda

### 3.1 Topic 1
- Discussion points
- Decisions made
- Action items assigned

### 3.2 Topic 2
- Discussion points
- Decisions made
- Action items assigned

## 4. Action Items

### 4.1 New Action Items
| Item | Assigned To | Due Date | Notes |
|------|-------------|-----------|-------|
| | | | |

### 4.2 Previous Action Items
| Item | Status | Notes |
|------|--------|-------|
| | | |

## 5. Next Meeting

**Date:** Next meeting date  
**Time:** Scheduled time  
**Location:** Planned location  
**Agenda Items:**
- List of items for next meeting

## 6. Closing

**Time Adjourned:** End time  
**Minutes Recorded By:** Recorder name  
**Minutes Approved By:** Approver name  

---

**Note:** These minutes are classified {{security_level}}. Handle according to security protocols.