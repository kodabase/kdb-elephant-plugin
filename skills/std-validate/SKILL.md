---
name: std-validate
description: Validate code files against project standards and RFCs
trigger: when the user wants to check code compliance, validate against standards, or review for RFC violations
---

# Standards Validation

Validate code against the project's active standards.

## Usage
/std-validate [file_path]

## Instructions
1. If a file path is provided, read the file and use the `validate_code` MCP tool
2. If no file path, ask the user which file(s) to validate
3. Present violations grouped by severity (MUST > SHOULD > MAY)
4. For each violation, show the rule ID, description, and a concrete fix suggestion
5. End with a compliance score: (passed / total) * 100%

## Output Format
```
Compliance Report: {file_path}
Score: {score}%

MUST Violations:
  - [RFC-001-R03] Description...
    Fix: ...

SHOULD Warnings:
  - [RFC-002-R01] Description...
    Suggestion: ...
```
