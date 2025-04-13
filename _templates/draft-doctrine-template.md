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
  ["Public", "Member", "Internal", "Limited Release"],
  ["L0", "L1", "L2", "L3R"]
);
const author = await tp.system.prompt("Enter your name");
-%>
title: "Doctrinal Publication <% title %>"
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

## Document Information

**Document ID:** <% role %>-<% type %>-<% tp.date.now("YYYY") %>001-<% security_classification %>  
**Version:** 1.0.0  
**Security Classification:** <% security_classification %>  
**Created By:** Cde <% author %>  
**Creation Date:** <% tp.date.now() %>  
**Last Modified:** <% lastmod %>  
**Next Review Date:** <% next_review %>  

## Preface

### Document Purpose

Brief explanation of why this doctrine exists and its role in the organization

### Doctrinal Hierarchy

Position of this document in relation to other doctrine and documents

### Usage Guidelines

How to use and interpret this doctrinal document

## 1. Foundations

### 1.1 Core Principles

Fundamental, unchanging principles that guide this area

- Principle One
  - Key aspects
  - Rationale
  - Application scope

### 1.2 Philosophical Framework

Theoretical and ideological basis

- Theoretical foundations
- Historical context
- Current understanding

### 1.3 Strategic Context

How this doctrine supports organizational strategy

- Strategic alignment
- Long-term objectives
- Critical success factors

## 2. Conceptual Framework

### 2.1 Key Concepts

Essential ideas and constructs

- Definitions
- Relationships
- Critical distinctions

### 2.2 Operating Model

How the concepts work together

- System overview
- Component interaction
- Feedback loops

### 2.3 Success Criteria

How to evaluate effectiveness

- Key indicators
- Measurement approaches
- Evaluation frameworks

## 3. Implementation Framework

### 3.1 Organizational Integration

How this doctrine is applied across the organization

- Structural considerations
- Role implications
- Resource requirements

### 3.2 Decision-Making Framework

How to make decisions using this doctrine

- Decision criteria
- Evaluation process
- Authority levels

### 3.3 Development Pathway

How implementation evolves with organizational growth

- Stage-based evolution
- Capability development
- Resource scaling

## 4. Operational Guidelines

### 4.1 Basic Application

Fundamental implementation approaches

- Core practices
- Essential methods
- Standard procedures

### 4.2 Advanced Implementation

More sophisticated applications

- Complex scenarios
- Advanced techniques
- Special considerations

### 4.3 Integration Points

How this doctrine interacts with other areas

- Cross-functional aspects
- Coordination requirements
- Boundary management

## 5. Development Framework

### 5.1 Individual Development

How individuals grow in this area

- Knowledge requirements
- Skill progression
- Competency development

### 5.2 Collective Development

How the organization develops capability

- Group learning
- Capability building
- Cultural integration

### 5.3 Leadership Requirements

How leaders support and use this doctrine

- Leadership roles
- Oversight responsibilities
- Development duties

## 6. Evolution and Adaptation

### 6.1 Review Framework

How the doctrine is maintained and updated

- Review triggers
- Update process
- Version control

### 6.2 Adaptation Guidelines

How to adapt the doctrine for specific needs

- Customization principles
- Local application
- Special circumstances

### 6.3 Future Development

How the doctrine should evolve

- Growth considerations
- Technology impact
- Environmental changes

## 7. Supporting Elements

### 7.1 Resources Required

What's needed to implement this doctrine

- Material requirements
- Personnel needs
- System requirements

### 7.2 Risk Management

How to handle risks in this area

- Risk identification
- Mitigation strategies
- Contingency planning

### 7.3 Quality Assurance

How to maintain standards

- Quality criteria
- Monitoring methods
- Improvement processes

## Appendices

### Appendix A: Key Terms and Concepts

Detailed definitions and explanations

### Appendix B: Decision-Making Tools

Practical tools for implementation

### Appendix C: Development Resources

Supporting materials and references

### Appendix D: Integration Guidelines

Detailed integration instructions

---

## Version History

| Version | Date | Changes | Author |
|---------|------|----------|---------|
| [X.Y] | [YYYY-MM-DD] | [Description] | [Name] |

## Reviews and Approvals

|   Role   | Name | Date |
|----------|------|------|
| Author   |      |      |
| Reviewer |      |      |
| Approver |      |      |

---

**Contact Information:**  
For questions about this doctrine, contact:  
[Role/Position]  
[Contact details]
