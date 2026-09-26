# Backend

FastAPI app that serves the static site and JSON APIs.

## Layout

- `app/main.py` — FastAPI application
- `static/` — static files served to the browser (hello page for scaffolding; later Next export)
- `pyproject.toml` / `uv.lock` — dependencies managed with `uv`

## Local commands

```bash
uv sync
uv run uvicorn app.main:app --reload --port 8000
```

## Endpoints (Part 2)

- `GET /` — hello HTML page
- `GET /api/health` — `{"status":"ok"}`
- `GET /api/hello` — `{"message":"hello from FastAPI"}`

## Runtime

The Docker image runs uvicorn on port 8000. Root `.env` is passed in via start scripts.
