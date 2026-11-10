# Troubleshooting file imports

Find your symptom below. Each entry lists the likely cause and the fix, most common first.

## Upload succeeds but `string_count` is 0

**Cause:** the `format` value doesn't match the file's structure. Lingua parsed the file but found
nothing it recognizes as a string.

**Fix:**

- For nested JSON (`{"cart": {"empty": "..."}}`), use `json-icu`, not `json-flat`.
- For Android XML, confirm the root element is `<resources>`.
- Open the file and confirm it isn't empty or entirely commented out.

## Upload fails with `422 unparseable_file`

**Cause 1: encoding.** The file isn't valid UTF-8 or UTF-16.

```bash
file -i en.json
```

If the output shows anything other than `utf-8` or `utf-16`, convert it:

```bash
iconv -f WINDOWS-1252 -t UTF-8 en.json > en.utf8.json
```

**Cause 2: syntax.** The file has a trailing comma, an unescaped quote, or an unclosed tag. Validate
it:

```bash
python -m json.tool en.json > /dev/null
```

**Cause 3: size.** The file is larger than 20 MB. Split it by feature area.

## Placeholders are missing in the translated file

**Cause:** the placeholder syntax isn't recognized for the chosen format, so translators saw it as
ordinary text.

**Fix:** match the placeholder style to the format.

| Format | Recognized placeholders |
| --- | --- |
| `json-icu` | `{name}`, `{count, plural, ...}` |
| `json-flat` | `{name}`, `{{name}}`, `%s`, `%d` |
| `android-xml` | `%1$s`, `%2$d` |
| `apple-strings` | `%@`, `%d`, `%1$@` |

Re-upload with `replace=true`, then start a new job.

## Hebrew or Arabic text displays reversed or with punctuation on the wrong side

This is a rendering issue in your app, not an import problem. The file content is correct. See
[Display right-to-left translations correctly](rtl-guide.md).

## Some strings come back in English

**Cause:** those strings weren't translated yet, and downloads fall back to source text by default.

**Fix:** check the job status. If it's `completed`, find untranslated keys with
`GET /projects/{id}/files/{name}/stats?locale=he-IL`. To get blanks instead of English, download
with `fallback=empty`.

## Still stuck?

Contact support with:

- the `request_id` from the error response,
- the file, or a minimal sample that reproduces the problem,
- the exact `format` value you used.
