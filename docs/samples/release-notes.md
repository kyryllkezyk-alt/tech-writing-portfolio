# Lingua 4.0 release notes

**Released:** August 4, 2026

Lingua 4.0 adds ICU plural support for JSON, webhook signatures, and per-key rate limits. It also
removes API v1. If you call v1 endpoints, read [Breaking changes](#breaking-changes) before you
upgrade.

## Breaking changes

### API v1 is removed

Requests to `/v1/*` now return `410 Gone`.

**Who is affected:** integrations that call any URL starting with `https://api.lingua.example/v1/`.

**What to do:**

1. Search your code for `/v1/`.
2. Change the base URL to `/v2/`.
3. Replace these renamed fields:

    | v1 | v2 |
    | --- | --- |
    | `languages` | `target_locales` |
    | `source_lang` | `source_locale` |
    | `page` / `per_page` | `cursor` / `limit` |

4. Switch list calls to cursor pagination. See [Pagination](api-reference.md#conventions).

### Webhook deliveries are signed

Every delivery now includes a `Lingua-Signature` header. Unsigned deliveries are no longer sent.

**What to do:** verify the signature in your receiver. A sample implementation is in
[Verify the signature](api-reference.md#verify-the-signature). Your webhook secret is under
**Settings > Webhooks**.

## New features

- **ICU MessageFormat in JSON.** Use `format=json-icu` to upload plurals and selects. Translators
  see each plural form for their language; Hebrew gets `one`, `two` and `other`.
- **Idempotency keys.** Send `Idempotency-Key` with any `POST` to make retries safe.
- **Fallback control.** Downloads accept `fallback=empty` to leave untranslated strings blank
  instead of returning source text.

## Improvements

- Rate limits are now per API key instead of per account, so one busy pipeline no longer
  throttles your other integrations.
- Uploading a file with a byte order mark no longer creates a phantom first key.

## Fixed issues

- Apple `.strings` files encoded in UTF-16 LE without a BOM failed with `unparseable_file`.
- Job status sometimes stayed at `in_review` after the reviewer approved all segments.

## Deprecations

`workflow: "human-fast"` is deprecated and will be removed in 4.2. Use `human` with `due_at`.
