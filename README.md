# mcpChat

A command-line AI chat application that lets you interact with documents using Claude. Built on the MCP (Model Context Protocol) architecture, it connects an AI-powered chat interface to a document server that exposes tools, resources, and prompt templates.

## Overview

mcpChat implements the complete MCP architecture — a custom MCP server that exposes tools, resources, and prompt templates, paired with a custom MCP client that connects to it over stdio transport. The client feeds retrieved context into a Claude-powered conversational loop, all surfaced through a rich terminal interface.

## MCP Architecture

### MCP Server
Built using FastMCP, the server exposes three categories of MCP primitives:

- **Tools** — `read_document` and `edit_document` allow Claude to read and modify documents during a conversation
- **Resources** — URI-addressable endpoints (`docs://documents`, `docs://documents/{doc_id}`) that the client can fetch directly
- **Prompts** — reusable prompt templates (e.g. `format`) that inject structured instructions into the message history

### MCP Client
A custom `MCPClient` class manages the full lifecycle of an MCP session:

- Spawns the server as a subprocess and connects via stdio transport
- Initializes and holds a `ClientSession` for the duration of the app
- Exposes typed methods for `list_tools`, `call_tool`, `list_prompts`, `get_prompt`, and `read_resource`

Multiple MCP clients can be registered simultaneously, enabling tool aggregation across servers.

## Features

- **Document-aware chat** — reference any document in your query using `@filename` and its content is automatically injected as context
- **Slash commands** — run predefined prompt templates (e.g. `/format report.pdf`) directly from the CLI
- **Tab completion** — autocomplete for `@documents` and `/commands` powered by `prompt_toolkit`
- **Multi-server support** — pass additional MCP server scripts as CLI arguments to extend available tools

## How it works

The app runs two components side by side:

- **MCP Server** — manages a document store and exposes `read_document` and `edit_document` tools, document resources, and prompt templates
- **MCP Client + Claude** — the CLI connects to the server over stdio, retrieves context, and sends messages to the Anthropic API

When you type a message, the app resolves any `@document` references, builds a context-aware prompt, and streams the response from Claude back to the terminal.

## Setup

1. Create a `.env` file in the project root:

```
ANTHROPIC_API_KEY="your-api-key"
CLAUDE_MODEL="claude-sonnet-4-6"
```

2. Install dependencies and run:

```bash
uv venv
source .venv/bin/activate
uv pip install -e .
uv run main.py
```

## Author

Naveen Soni
