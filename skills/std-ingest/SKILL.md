---
name: std-ingest
description: Import standards documents (RFCs, ADRs, guidelines) into the Elephant knowledge base
trigger: when the user wants to import, add, or update standards documents
---

# Standards Ingestion

Import standards documents into the Elephant knowledge base.

## Usage
/std-ingest <path>

## Instructions
1. Determine if the path is a file or directory
2. Use the `elephant ingest` CLI command or suggest the user run it
3. Report the results: documents ingested, chunks created, rules extracted
4. If documents have no YAML frontmatter, they must use the inline format:
   ```
   # RFC-001: Title
   **Status**: **APPROVED**
   **Version**: 1.0.0
   ```
5. Supported document types: RFC, ADR, Guideline, Spec, Pattern

## Supported Formats
- YAML frontmatter (--- delimited)
- Inline markdown metadata (# Header + **Key**: Value)
