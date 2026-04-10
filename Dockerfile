FROM python:3.13-slim

WORKDIR /app

COPY pyproject.toml .
COPY main.py .
COPY mcp_server.py .
COPY mcp_client.py .
COPY core/ ./core/

RUN pip install uv
RUN uv pip install --system .

CMD ["python", "main.py"]
