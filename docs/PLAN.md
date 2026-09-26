# Project plan

Locked decisions:

- Board storage: one JSON blob per user/board (same shape as frontend `BoardData`)
- AI: Python `cursor-sdk`, model `composer-2.5`, instruct JSON in the prompt, parse in backend
- Chat history: browser session only (not persisted)
- Auth: hardcoded `user` / `password`; DB still multi-user-ready
- Runtime: single Docker container; FastAPI serves Next static export at `/`; `uv` for Python; SQLite auto-created; start/stop scripts in `scripts/`

---

## Part 1: Plan

- [x] Enrich this document with per-part checklists, tests, and success criteria
- [x] Create `frontend/AGENTS.md` describing the existing frontend
- [x] Sync root `AGENTS.md` model to `composer-2.5`
- [x] User approves the plan

**Success:** Plan approved; docs reflect locked decisions.

---

## Part 2: Scaffolding

**Goal:** Docker + FastAPI hello-world serving static HTML and a sample API.

- [x] Add root `Dockerfile` (Python-only with static `backend/static/index.html`)
- [x] Scaffold `backend/` with `pyproject.toml` via `uv`, FastAPI + uvicorn
- [x] `GET /` serves hello HTML; `GET /api/health` returns JSON
- [x] Load `.env` into the container (`CURSOR_API_KEY` available later; unused in Part 2)
- [x] `scripts/start` + `scripts/stop` for Mac/Linux (`.sh`) and Windows (`.ps1` / `.bat`)
- [x] Update `backend/AGENTS.md` and `scripts/AGENTS.md`

**Tests / success:** Start script brings up the app; browser shows hello page; health endpoint returns ok; stop script tears down cleanly.

Verified end-to-end with Docker: `.\scripts\start.ps1` serves `/` and `/api/health`, `.env` injects `CURSOR_API_KEY`, `.\scripts\stop.ps1` removes the container. Fixed Windows start/stop scripts so `docker rm -f` does not fail when the container is absent.

---

## Part 3: Frontend static serve

**Goal:** Demo Kanban at `/` from Next static export.

- [ ] Set Next `output: 'export'` in `frontend/next.config.ts`
- [ ] Dockerfile builds frontend then copies `out/` into backend static dir
- [ ] FastAPI mounts static export at `/`
- [ ] Keep existing Vitest + Playwright green

**Tests / success:** `npm run test:all` passes; container at `/` shows Kanban Studio with 5 columns and client-side drag/drop.

---

## Part 4: Fake sign-in

**Goal:** Gate the board behind login; logout works.

- [ ] Login UI with credentials `user` / `password`
- [ ] Backend `POST /api/login`, `POST /api/logout`, `GET /api/me` with HTTP-only session cookie
- [ ] Frontend hides Kanban until authenticated; logout clears session
- [ ] Wrong credentials show a clear error

**Tests / success:** Unauthenticated cannot see board; valid login shows board; logout returns to login; bad password rejected.

---

## Part 5: Database modeling (sign-off gate)

**Goal:** Document schema; get approval before implementing APIs.

Proposed schema (JSON blob):

```text
users(id INTEGER PK, username TEXT UNIQUE, password_hash TEXT)
boards(user_id INTEGER UNIQUE FK -> users.id, data TEXT NOT NULL)
```

- `data` is JSON matching `BoardData` (`columns`, `cards`)
- On first DB create: seed user `user` and one board with frontend `initialData`
- Document in `docs/DATABASE.md`

**Tests / success:** User approves `docs/DATABASE.md` before Part 6.

---

## Part 6: Backend Kanban API

**Goal:** Board APIs backed by SQLite.

- [ ] Init SQLite on startup if missing
- [ ] `GET /api/board` — current user's board JSON
- [ ] `PUT /api/board` — replace board JSON (light shape validation)
- [ ] Auth required on board routes
- [ ] pytest coverage for seed, get, put, auth rejection

**Tests / success:** Fresh container creates DB + seed; get returns seed board; put persists across restart; unauthenticated calls return 401.

---

## Part 7: Frontend + Backend persistence

**Goal:** Real persistent Kanban.

- [ ] Load board from `GET /api/board` after login
- [ ] Persist on card add/edit/delete/move and column rename via `PUT /api/board`
- [ ] Simple loading/error states
- [ ] Update unit/e2e for API-backed flow

**Tests / success:** Refresh keeps board state; second session with same user sees same data.

---

## Part 8: AI connectivity

**Goal:** Prove Cursor SDK works in the backend.

- [ ] Add `cursor-sdk`; read `CURSOR_API_KEY` from env
- [ ] Endpoint or test prompts `composer-2.5` with `2+2` and returns the reply
- [ ] pytest mocks the SDK; document live-key path

**Tests / success:** Mocked unit test passes; with real key, reply contains `4`.

---

## Part 9: AI board + chat turn

**Goal:** One chat turn with board context and optional board update.

- [ ] `POST /api/ai/chat` accepts `{ message, history[], board }` (history from client only)
- [ ] Prompt includes board JSON + history + message; instructs strict JSON: `reply`, optional `board`
- [ ] Backend parses JSON; if `board` present, persist
- [ ] Return `{ reply, board }` to the client
- [ ] pytest with mocked Agent for update and no-update cases

**Tests / success:** Mocked move updates DB; Q&A-only leaves board unchanged; malformed output does not corrupt DB.

---

## Part 10: AI sidebar UI

**Goal:** Chat sidebar that refreshes the board when the model updates it.

- [ ] Sidebar chat UI using project colors
- [ ] Message list in React state (session only)
- [ ] On send: call `/api/ai/chat`; append assistant `reply`
- [ ] If response includes `board`, replace local board state
- [ ] e2e with mocked API

**Tests / success:** User can chat without leaving the board; AI-driven card changes appear without manual refresh.
