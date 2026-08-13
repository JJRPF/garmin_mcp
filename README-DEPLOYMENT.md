# Deployment Guide for Garmin MCP Server (Cloud Free Tier)

This guide walks you through deploying your authenticated **Garmin MCP Server** to Render's Free Tier web service.

---

## 1. Prerequisites

- A free [Render.com](https://render.com) account.
- A GitHub account.

---

## 2. GitHub Repository Setup

1. Push your local `garmin_mcp` repository to GitHub:
   ```bash
   cd /Users/JJR/Code/garmin_mcp
   git init
   git add .
   git commit -m "Configure garmin_mcp for Cloud Free Tier deployment"
   git remote add origin https://github.com/YOUR_GITHUB_USERNAME/garmin_mcp.git
   git push -u origin main
   ```

---

## 3. Deploy to Render Free Tier

1. Log into your [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** -> **Blueprint** (or **Web Service**).
3. Connect your `garmin_mcp` GitHub repository.
4. Render will automatically detect `render.yaml`:
   - **Service Name**: `garmin-mcp`
   - **Environment**: Docker
   - **Plan**: Free
5. Set the **`GARMIN_TOKENS_BASE64`** Environment Variable:
   - Copy the full content of `garmin_tokens_b64.txt` (or paste the base64 token string generated during auth).
   - Add Environment Variable:
     - **Key**: `GARMIN_TOKENS_BASE64`
     - **Value**: *(Paste your base64 string)*
6. Click **Apply** or **Create Web Service**.

Once deployed, Render will provide a public HTTPS URL, for example:
`https://garmin-mcp.onrender.com`

---

## 4. MCP Client Configuration

Add your deployed server to your MCP client (e.g. Claude Desktop, Cursor, Antigravity, or custom LLM client) using Streamable HTTP / SSE:

```json
{
  "mcpServers": {
    "garmin": {
      "url": "https://garmin-mcp.onrender.com/sse"
    }
  }
}
```

---

## 5. Local Usage (Alternative)

You can also run the server directly on your local machine using standard `stdio` or `streamable-http`:

```json
{
  "mcpServers": {
    "garmin": {
      "command": "uvx",
      "args": ["--python", "3.12", "--from", "git+https://github.com/Taxuspt/garmin_mcp", "garmin-mcp"]
    }
  }
}
```
