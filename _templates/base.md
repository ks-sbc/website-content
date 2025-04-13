---
<%*
// Get user input through prompts
const sequence_number = await tp.system.prompt("Enter document sequence number. EX: 001, 002, etc");
const made_by = await tp.system.prompt("Enter your name");
const security_level = await tp.system.prompt("Enter security level");

-%>
title: "Insert document title here"
book_name: "<% book %>"
book_author: "<% author %>"
type: "Lesson Plan"
role: "Development|Secretary|President"
document_id: "{roleMap}-{typeMap}-<% tp.date.now('YYYY') %>-<% sequence_number %>-L0"
security_classification: <% security_level %>
created_by: "<% made_by %>"
date: <% tp.date.now() %>
lastmod: <% tp.date.now() %>
draft: true
version: "1.0.0"
next_review: <% tp.date.now("YYYY-MM-DD", 180) %>
tags:
   - "security/public"
   - "role/development"
   - "type/lesson_plan"
   - "function/education/study/general/<% tag_name %>"
---

<% await tp.file.rename(tp.frontmatter.document_id) %>

# <% tp.frontmatter.title %>

## Document Control Information

**Document ID:** {{doc_type}}-{{department}}-{{id}}  
**Version:** {{version}}  
**Security Classification:** {{security_level}}  
**Created By:** {{author}}  
**Creation Date:** {{date}}  
**Last Modified:** {{date}}  
**Next Review Date:** {{review_date}}  

## Overview

### Purpose
[Clear statement of document purpose]

### Scope
[Define document scope and applicability]

### Definitions

| Term | Definition |
|------|------------|
| | |

[Content begins here...]