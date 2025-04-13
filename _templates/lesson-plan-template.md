---
<%*
// Get user input through prompts
const sequence_number = await tp.system.prompt("Enter document sequence number. ex 001, 002, etc");
const book = await tp.system.prompt("Enter book title");
const author = await tp.system.prompt("Enter author name");
const made_by = await tp.system.prompt("Enter the name of the person who made this lesson plan");
const taught_by = await tp.system.prompt("Enter the name of the person who will teach this lesson");
const study_type = await tp.system.prompt("Is this a general or cadre study?");
const author_tag = author.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
const book_tag = book.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
const madeby_tag = made_by.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
const taughtby_tag = taught_by.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
// Create the document ID with the current year and the sequence number, and rename the document
const docId = `DEV-LPN-${tp.date.now('YYYY')}-${sequence_number}-L0`;
await tp.file.rename(docId);
-%>
title: "Lesson Plan - <% book %> - Session <% sequence_number %>"
role: "Development"
type: "Lesson Plan"
sequence_number: "<% sequence_number %>"
security_classification: "Public"
document_id: "<% docId %>"
book_name: "<% book %>"
book_author: "<% author %>"
lesson_created_by: "<% made_by %>"
lesson_taught_by: "<% taught_by %>"
study_type: "<% study_type %>"
date: <% tp.date.now() %>
lastmod: <% tp.date.now() %>
draft: true
version: "1.0.0"
next_review: <% tp.date.now("YYYY-MM-DD", 180) %>
tags:
   - "security/public"
   - "role/development"
   - "type/lesson_plan"
   - "function/education/study/<% study_type %>/<% author_tag %>/<% book_tag %>"
   - "function/education/study/taught_by/<% taught_by.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '') %>"
   - "function/education/study/created_by/<% made_by.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '') %>"
---


# <% tp.frontmatter.book_name %> - <% tp.frontmatter.book_author %> - Session <% tp.frontmatter.sequence_number %>

## Document Control Information

| **Document ID**           | **Version** | **Security Classification** | **Created By**    | **Creation Date** | **Last Modified** | **Next Review Date**       |
|---------------------------|-------------|-----------------------------|-------------------|-------------------|-------------------|----------------------------|
| <% docId %>               | <% tp.frontmatter.version %>       | <% tp.frontmatter.security_classification %>                      | Cde <% tp.frontmatter.lesson_created_by %> | <% tp.frontmatter.date %> | <% tp.frontmatter.lastmod %> | <% tp.frontmatter.next_review %> |

## Session Overview

### Reading Assignment
- **Chapters/Pages:** Specify reading range
- **Primary Text:** <% tp.frontmatter.book_name %>
- **Author:** <% author %>
- **Supplementary Materials:** Additional readings if any

### Learning Objectives
1. Theoretical Understanding
   - Key theoretical concept to grasp
   - Historical context to understand
   - Connections to make

2. Contemporary Applications
   - Current situations this applies to
   - Local/regional relevance
   - Practical implementation possibilities

## Preparation Checklist

### Before Session

-   Review reading thoroughly
-   Prepare lecture notes
-   Develop contemporary examples
-   Create discussion questions
-   Setup meeting space
-   Test any technical equipment

### Materials Needed

| Item | Purpose | Status |
|------|----------|---------|
| Primary text | Core reading |   |
| Lecture notes | Presentation |   |
| Handouts | Supporting materials |   |
| Discussion guide | Facilitation |   |


## Session Structure (2 Hours)

### Lecture Component (30 minutes)

1. Historical Context
   - Key background information
   - Historical conditions
   - Development of ideas

2. Core Concepts
   - Main theoretical points
   - Key arguments
   - Critical insights

3. Modern Parallels
   - Contemporary examples
   - Current applications
   - Local relevance

### Group Discussion (80 minutes)

#### Discussion Topics

1. Topic One
   - Contemporary relevance:
     - Current situation 1
     - Current situation 2
   - Discussion questions:
     - Question exploring historical concept
     - Question connecting to present day
     - Question about practical application

2. Topic Two
   - Contemporary relevance:
     - Current situation 1
     - Current situation 2
   - Discussion questions:
     - Question exploring historical concept
     - Question connecting to present day
     - Question about practical application

#### Practical Application Focus

- How does this apply to our current conditions?
- What are the concrete lessons we can implement?
- How can we adapt these ideas to our context?

### Closing (10 minutes)

- Summarize key points
- Preview next session
- Assign next reading

## Documentation

### Discussion Notes

- Key point raised
- Important connection made
- Practical application suggested
- Question for further exploration
- Relevant current event discussed

### Next Steps

- Reading assignment: Pages/Chapters
- Additional materials: Any supplementary readings
- Preparation notes: Specific areas to focus on


## Appendices

### A. Quick Reference

Key terms, concepts, and definitions

### B. Current Events
Relevant news, situations, or developments to reference

### C. Further Reading
Additional resources for interested participants

---

**Contact Information:**  
For questions about this session plan, contact:  
Education Committee  
Contact details to be added
