# REST API reference

The Lingua API v2 lets you manage projects, source files and translation jobs programmatically.

**Base URL:** `https://api.lingua.example/v2`

## Authentication

Send an API key in the `Authorization` header with every request:

```http
Authorization: Bearer lng_live_xxxxxxxx
```

Keys are scoped. A request that needs a scope the key lacks returns `403 insufficient_scope`.

| Scope | Grants |
| --- | --- |
| `projects:read` | List and read projects, files and jobs |
| `projects:write` | Create and update projects, upload files, start jobs |
| `webhooks:manage` | Create and delete webhook subscriptions |

## Conventions

**Requests and responses** use JSON, UTF-8. Timestamps are ISO 8601 in UTC.

**Locales** use BCP 47 tags: `en-US`, `he-IL`, `pt-BR`.

**Pagination.** List endpoints are cursor-based. Pass `limit` (1–100, default 25) and the
`next_cursor` value from the previous response as `cursor`. When `next_cursor` is `null`, you have
reached the last page.

**Idempotency.** For any `POST`, send an `Idempotency-Key` header with a unique value. If a request
with the same key arrives within 24 hours, Lingua returns the original response instead of creating
a duplicate. Use this for every job you start from an automated pipeline.

**Rate limits.** 600 requests per minute per key. Every response includes:

| Header | Meaning |
| --- | --- |
| `X-RateLimit-Limit` | Requests allowed in the window |
| `X-RateLimit-Remaining` | Requests left in the window |
| `X-RateLimit-Reset` | Unix time when the window resets |

When the limit is exceeded, the API returns `429` with a `Retry-After` header in seconds.

## Projects

### Create a project

`POST /projects`

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `name` | string | yes | Display name, 1–120 characters |
| `source_locale` | string | yes | BCP 47 tag of the source language |
| `target_locales` | string[] | yes | One or more BCP 47 tags |
| `tm_id` | string | no | Translation memory to attach. Default: a new empty memory |

```json title="Response 201"
{
  "id": "prj_8f2a1c",
  "name": "Quickstart",
  "source_locale": "en-US",
  "target_locales": ["he-IL"],
  "tm_id": "tm_51d0e3",
  "created_at": "2026-08-05T10:14:22Z"
}
```

### List projects

`GET /projects?limit=25&cursor=...`

Returns `{ "data": [Project], "next_cursor": string | null }`.

## Files

### Upload a source file

`POST /projects/{project_id}/files` — `multipart/form-data`

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `file` | binary | yes | The source file, up to 20 MB |
| `format` | string | yes | One of the [supported formats](#supported-formats) |
| `replace` | boolean | no | Overwrite a file with the same name. Default `false` |

Uploading a file with an existing name and `replace=false` returns `409 file_exists`.

### Download a translated file

`GET /projects/{project_id}/files/{file_name}/download?locale={locale}`

Returns the file in its original format. Untranslated strings fall back to the source text unless
you pass `fallback=empty`.

### Supported formats

| `format` value | Extension | Notes |
| --- | --- | --- |
| `json-flat` | `.json` | Flat key–value pairs |
| `json-icu` | `.json` | ICU MessageFormat, including plurals |
| `xliff-2` | `.xlf` | XLIFF 2.0; notes are passed to translators |
| `android-xml` | `.xml` | `<plurals>` supported |
| `apple-strings` | `.strings` | UTF-16 and UTF-8 accepted |
| `po` | `.po` | Gettext, including `msgctxt` |

## Jobs

### Start a translation job

`POST /projects/{project_id}/jobs`

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `target_locales` | string[] | yes | Subset of the project's target locales |
| `workflow` | string | yes | `machine-only`, `machine-plus-review` or `human` |
| `due_at` | string | no | Requested deadline. `human` jobs only |

### Get a job

`GET /jobs/{job_id}`

| `status` | Meaning |
| --- | --- |
| `queued` | Waiting for capacity |
| `translating` | Machine or human translation in progress |
| `in_review` | Assigned to a reviewer |
| `completed` | Translations are available for download |
| `failed` | See `error.code` |

## Webhooks

Subscribe to `job.completed` and `job.failed` instead of polling.

`POST /webhooks` with `{ "url": "https://...", "events": ["job.completed"] }`.

### Verify the signature

Each delivery includes `Lingua-Signature: t=<timestamp>,v1=<hex>`. Compute an HMAC-SHA256 of
`<timestamp>.<raw body>` with your webhook secret and compare it with `v1` in constant time.
Reject deliveries whose timestamp is more than five minutes old.

```python
import hmac, hashlib, time

def verify(secret: str, header: str, body: bytes) -> bool:
    parts = dict(p.split("=", 1) for p in header.split(","))
    if abs(time.time() - int(parts["t"])) > 300:
        return False
    expected = hmac.new(
        secret.encode(), f'{parts["t"]}.'.encode() + body, hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected, parts["v1"])
```

## Errors

Errors return a consistent body:

```json
{ "error": { "code": "file_exists", "message": "A file named en.json already exists.", "request_id": "req_93b" } }
```

| HTTP | `code` | What to do |
| --- | --- | --- |
| 400 | `invalid_request` | Fix the field named in `message` |
| 401 | `unauthenticated` | Check the `Authorization` header |
| 403 | `insufficient_scope` | Use a key with the required scope |
| 404 | `not_found` | Check the ID |
| 409 | `file_exists` | Pass `replace=true` or rename the file |
| 422 | `unparseable_file` | The file doesn't match `format`. See [Troubleshooting imports](troubleshooting.md) |
| 429 | `rate_limited` | Wait for `Retry-After` seconds |
| 5xx | `internal` | Retry with exponential backoff; include `request_id` if you contact support |
