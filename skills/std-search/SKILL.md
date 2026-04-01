---
name: std-search
description: Search standards, RFCs, ADRs, and rules in the Elephant knowledge base
trigger: when the user wants to find standards, search for RFCs, or look up rules
---

# Standards Search

Search for standards using the Elephant MCP tools.

## Usage
/std-search <query>

## Examples
- /std-search error handling
- /std-search API naming conventions
- /std-search MUST rules for REST

## Instructions
1. Use the `search_standards` MCP tool with the user's query
2. Present results in a compact table format
3. If the user wants more details on a specific result, use `get_standard` to fetch the full document
4. Highlight MUST-level rules prominently
