# Python Code Analysis Template

You are an {{ROLE:expert Python developer}} tasked with analyzing and improving a piece of Python code.

This code uses {{TECHNOLOGY_CONTEXT:description of the technology, framework, or library the code uses}} functionality, which provides features like {{TECHNOLOGY_FEATURES:list key features or capabilities}}.

## Task Description
{{TASK_DESCRIPTION:The specific task or purpose of the code}}

First, examine the following Python code:

<python_code>
{{PYTHON_CODE}}
</python_code>

Conduct an in-depth analysis of the code. Consider the following aspects:

{{ANALYSIS_ASPECTS:
- Code structure and organization
- Naming conventions and readability
- Efficiency and performance
- Potential bugs or errors
- Adherence to Python best practices and PEP 8 guidelines
- Use of appropriate data structures and algorithms
- Error handling and edge cases
- Modularity and reusability
- Comments and documentation
}}

Write your analysis inside <analysis> tags. Be extremely comprehensive in your analysis, covering all aspects mentioned above and any others you deem relevant.

{{#if IDENTIFIED_ISSUES}}
Now, consider the following identified issues:

<identified_issues>
{{IDENTIFIED_ISSUES}}
</identified_issues>
{{/if}}

Using chain of thought prompting, explain how to fix {{#if IDENTIFIED_ISSUES}}these issues{{else}}any issues you've identified{{/if}}. Break down your thought process step by step, considering different approaches and their implications. Write your explanation inside <fix_explanation> tags.

{{#if INCLUDE_SEARCH}}
Based on your analysis and the fixes you've proposed, come up with a search term that might be useful to find additional information or solutions. Write your search term inside <search_term> tags.

Use the {{RESEARCH_TOOL:Perplexity}} plugin to search for information using the search term you created. Analyze the search results and determine if they provide any additional insights or solutions for improving the code.
{{/if}}

Finally, provide the full, updated, and unabridged code with the appropriate fixes for the identified issues. Remember:

- Do NOT change any existing functionality unless it is critical to fixing the previously identified issues.
- Only make changes that directly address the identified issues or significantly improve the code based on your analysis {{#if INCLUDE_SEARCH}}and the insights from {{RESEARCH_TOOL:Perplexity}}{{/if}}.
- Ensure that all original functionality remains intact.

{{ADDITIONAL_GUIDELINES:}}

You can take multiple messages to complete this task if necessary. Be as thorough and comprehensive as possible in your analysis and explanations. Always provide your reasoning before giving any final answers or code updates.