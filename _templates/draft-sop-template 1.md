---
<%*
// Get user input through prompts
const title = await tp.system.prompt("Enter document title");
const type = await tp.system.suggester(
  ["SOP", "Minutes", "Training", "Doctrine", "Guide", "Reference", "Curriculum", "Journal", "Statement"], 
  ["SOP", "MIN", "TRN", "DCT", "GDE","REF", "CUR", "JNL", "STM"]
);
const role = await tp.system.suggester(
  ["Education", "Security", "Operations"],
  ["EDU", "SEC", "OPS"]
);
const security = await tp.system.suggester(
  ["Public", "Candidate", "Cadre", "Limited Release"],
  ["L0", "L1", "L2", "L3R"]
);
const author = await tp.system.prompt("Enter your name");
-%>
title: "<% title %>"
type: "<% type %>"
role: "<% role %>"
security_classification: "<% security %>"
author: "<% author %>"
date: <% tp.date.now() %>
lastmod: <% tp.date.now() %>
draft: true
version: "1.0.0"
next_review: <% tp.date.now("YYYY-MM-DD", 180) %>
---

# Standard Operating Procedure Template

## Document Control Information

**Document ID:** <% role %>-<% type %>-<% tp.date.now("YYYY") %>001-<% security_classification %>  
**Version:** 1.0.0  
**Security Classification:** <% security_classification %>  
**Created By:** Cde <% author %>  
**Creation Date:** <% tp.date.now() %>  
**Last Modified:** <% lastmod %>  
**Next Review Date:** <% next_review %>  

### Version History

| Version | Date | Modified By | Description of Changes |
|---------|------|-------------|------------------------|
| 1.0.0 | <% tp.date.now() %> | <% author %> | Initial version |

### Approval History

| Role | Name | Date |
|------|------|------|
| Author | <% author %> | <% tp.date.now() %> |
| Reviewer | | |
| Approver | | |

## 1. Overview

### 1.1 Purpose

Clear statement of procedure purpose

### 1.2 Scope

Define what the procedure covers and what it doesn't

### 1.3 Definitions

| Term | Definition |
|------|------------|
| | |

## 2. Roles and Responsibilities

| Role | Responsibilities |
|------|-----------------|
| | |

## 3. Required Resources

### 3.1 Materials

List required materials

### 3.2 Systems Access

List required systems and permissions

### 3.3 Documentation

List required documentation

## 4. Procedure

### 4.1 Prerequisites

List conditions that must be met before starting

### 4.2 Process Steps

1. **First step**
   - Details
   - Warnings
   - Expected outcomes

2. **Second step**
   - Details
   - Warnings
   - Expected outcomes

### 4.3 Decision Points

Document key decision points and criteria

### 4.4 Expected Outcomes

Describe what success looks like

## 5. Quality Control

### 5.1 Monitoring Requirements

Specify what needs to be monitored

### 5.2 Success Metrics

Define how success will be measured

## 6. Training Requirements

### 6.1 Initial Training

Specify required initial training

### 6.2 Ongoing Training

Specify recurring training needs

### 6.3 Competency Assessment

Define how competency will be assessed

## 7. Troubleshooting

### 7.1 Common Issues

| Issue | Solution |
|-------|----------|
| | |

### 7.2 Emergency Procedures

Define what to do if something goes wrong

## 8. Related Documents

### 8.1 References

List related documents

### 8.2 Forms and Templates

List required forms

## 9. Review and Maintenance

### 9.1 Review Schedule

Define review frequency and triggers

### 9.2 Feedback Process

Describe how to provide feedback

## Appendices

### Appendix A: Title

Additional information

### Appendix B: Title

Additional information

---

**Contact Information:**  
For questions about this procedure, contact:  
Role/Position  
kssocialistbookclub@protonmail.com