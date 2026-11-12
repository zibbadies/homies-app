# Homies Tasks API — Quick Reference (for calendar integration)

Base URL (dev): `http://localhost:8080` · All endpoints require `Authorization: Bearer <jwt>`.
Rate limit: 10 req/s on `/lists`. Errors always look like:
`{"error": {"message": "...", "code": "<error_code>"}}` with HTTP 400 (bad input/DB) or 403 (list belongs to another house).

## Data model

**List**
```json
{ "id": "12", "name": "Groceries" }
```

**Item (task)**
```json
{
  "id": "34",
  "text": "Buy milk",
  "completed": false,
  "author": "uuid-of-creator",
  "created_at": "2026-11-10T15:00:00Z",
  "due_at": "2026-11-15T18:00:00Z"
}
```
- `due_at` is **optional**: an RFC3339 UTC timestamp, or `null` when the task has no due date. Always present in responses.
- `id`s are strings (stringified ints).

## Endpoints

### 1. `GET /lists/` — all lists of the user's house
Response: `{"lists": [List, ...]}`

### 2. `GET /lists/:id/` — items of a list (paged, time-filtered)
Query params (all optional, combinable):
- `limit` — max items, default **10**, capped at 10
- `from` — RFC3339; only items with `created_at >= from`
- `to` — RFC3339; only items with `created_at < to`
- `due_on` — `YYYY-MM-DD`; only items whose `due_at` falls in that **UTC day**, i.e. `[YYYY-MM-DD 00:00:00Z, next day 00:00:00Z)`. Items with `due_at == null` are excluded. Invalid format → param silently ignored.

⚠️ Timezone note: `due_on` matches on the **UTC** day, not the device's local day.
For a local-time calendar, either accept the UTC-day approximation or compute the
local day's UTC boundaries yourself and use `from`/`to`... note however `from`/`to`
filter `created_at`, not `due_at` — so for exact local-day filtering, fetch with
`due_on` for the UTC day before, the day itself, and the day after (or just the day
itself if tasks are due during daytime) and filter `due_at` client-side.

Response: `{"items": [Item, ...]}` — ordered by `created_at` **DESC** (newest first).

**Calendar example:** tasks due on Nov 15, 2026:
`GET /lists/34/?due_on=2026-11-15`

### 3. `PUT /lists/:id/` — create item
Body:
```json
{ "text": "Buy milk", "due_at": "2026-11-15T18:00:00Z" }
```
- `text`: required, 3–511 chars.
- `due_at`: optional. Omit or send `null` → no due date. Must be RFC3339.

Response: `{"id": "34"}` (id of the new item)

### 4. `PATCH /lists/:id/:item_id` — update item
Body fields are all optional, patch-like:
```json
{ "text": "New text", "completed": true, "due_at": "2026-11-20T09:00:00Z" }
```
Branching logic (quirky, follow exactly):
- **`text` non-empty** → updates `text` (+ `due_at` if present, see below). `completed` is IGNORED on this branch.
- **`text` empty/absent** → sets `completed` to the given value (+ `due_at` if present).

`due_at` semantics:
- field **absent** → existing due date unchanged
- field **`null`** → due date removed
- field **RFC3339 string** → due date set (validated; bad format → 400 `basic_check_error`)

Response: `{}`

### 5. `DELETE /lists/:id/:item_id` — delete item
No body. Response: `{}`

## Error codes (in `error.code`)
`json_format_error`, `basic_check_error`, `list_not_found`, `item_not_found`,
`cant_access_this` (403), `internal_error`, `not_authenticated`.

## Calendar-relevant notes
- To toggle completion without touching text: `PATCH` with `{"completed": true}` (no `text` field).
- To set only a due date: `PATCH` with `{"due_at": "..."}` (no `text` field).
- Tasks without a due date (`due_at == null`) never match `due_on` and should not appear on a calendar.
- All timestamps are UTC (server timezone is UTC); convert to local time in the client.
- Pagination cap is 10 items per request and there is no offset/cursor param — a busy day with >10 due tasks in one list cannot be fully retrieved with `due_on` alone yet.
- There is no cross-list "all events" endpoint: iterate over `GET /lists/` and query each list.
