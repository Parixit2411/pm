# Frontend

Next.js App Router demo of a single Kanban board. Pure client-side state; not yet wired to a backend or Docker static export.

## Stack

- Next.js 16, React 19, TypeScript, Tailwind CSS 4
- `@dnd-kit` for drag and drop
- Vitest + Testing Library for unit tests
- Playwright for e2e (`tests/kanban.spec.ts`)

## Layout

- `src/app/page.tsx` — renders `KanbanBoard`
- `src/app/layout.tsx` — fonts (Space Grotesk display, Manrope body) and global CSS
- `src/app/globals.css` — CSS variables for the project color scheme

## Domain model (`src/lib/kanban.ts`)

- `Card`: `id`, `title`, `details`
- `Column`: `id`, `title`, `cardIds`
- `BoardData`: `columns`, `cards` (id -> Card map)
- `initialData`: five fixed columns (Backlog, Discovery, In Progress, Review, Done) with sample cards
- `moveCard(columns, activeId, overId)` — reorder within or across columns
- `createId(prefix)` — id helper for new cards

## Components

- `KanbanBoard` — board state, dnd context, rename / add / delete handlers
- `KanbanColumn` — column header (rename), card list, new-card form
- `KanbanCard` / `KanbanCardPreview` — card UI and drag overlay preview
- `NewCardForm` — add card to a column

## Scripts

- `npm run dev` — local Next dev server
- `npm run test:unit` / `test:e2e` / `test:all`

## Notes for later parts

- Part 3 will switch to `output: 'export'` and serve `out/` from FastAPI
- Part 7 will replace local `useState` board with API load/save
- Part 10 adds an AI chat sidebar; history stays in browser session only
