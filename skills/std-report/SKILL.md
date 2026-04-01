---
name: std-report
description: Generate a compliance report for the current project
trigger: when the user wants a compliance report, standards overview, or project audit
---

# Compliance Report

Generate a comprehensive compliance report.

## Usage
/std-report

## Instructions
1. Use `list_standards` to get all active standards
2. Use `validate_code` on recently changed files (or all files if requested)
3. Generate a summary report with:
   - Total standards loaded
   - Total rules (by level: MUST/SHOULD/MAY)
   - Compliance score per file
   - Overall compliance score
   - Top violations to address
4. Format as a clean markdown report
