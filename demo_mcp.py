import uvicorn
from mcp.server.fastmcp import FastMCP
from mcp.server.transport_security import TransportSecuritySettings
from starlette.applications import Starlette
from starlette.routing import Route
from starlette.responses import PlainTextResponse

sec_settings = TransportSecuritySettings(enable_dns_rebinding_protection=False)
fastmcp = FastMCP("Demo MCP Server", host="0.0.0.0", port=9999, transport_security=sec_settings)

@fastmcp.tool()
def echo(message: str) -> str:
    """Echoes back a message to verify MCP connection works."""
    return f"Echo from Demo MCP: {message}"

@fastmcp.tool()
def get_status() -> str:
    """Returns demo server status."""
    return "Demo MCP Server is online and fully functional!"

sse_app = fastmcp.sse_app()
streamable_app = fastmcp.streamable_http_app()

async def healthz(request):
    return PlainTextResponse("ok")

combined_routes = [
    Route("/", healthz, methods=["GET"]),
    Route("/healthz", healthz, methods=["GET"]),
]

seen = set()
for r in sse_app.routes + streamable_app.routes:
    p = getattr(r, "path", str(r))
    if p not in seen:
        seen.add(p)
        combined_routes.append(r)

app = Starlette(routes=combined_routes)
uvicorn.run(app, host="0.0.0.0", port=9999)
