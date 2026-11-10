# Quickstart: translate your first file

In this tutorial you upload an English resource file to Lingua, request a Hebrew translation, and
download the translated file. It takes about ten minutes.

**You'll learn how to:**

- authenticate with an API key,
- create a project and upload a source file,
- start a translation job and check its status,
- download the translated file.

## Before you start

You need:

- a Lingua account with the **Project admin** role,
- `curl` 7.68 or later,
- a JSON resource file. If you don't have one, save this as `en.json`:

```json title="en.json"
{
  "greeting": "Welcome back, {name}!",
  "cart.empty": "Your cart is empty.",
  "cart.items": "{count, plural, one {# item} other {# items}}"
}
```

## Step 1: Create an API key

1. In the Lingua dashboard, go to **Settings > API keys**.
2. Click **Create key**, name it `quickstart`, and select the `projects:write` scope.
3. Copy the key and store it in an environment variable:

    ```bash
    export LINGUA_API_KEY="lng_live_..."
    ```

!!! warning
    The key is shown once. If you lose it, revoke it and create a new one.

## Step 2: Create a project

```bash
curl -s https://api.lingua.example/v2/projects \
  -H "Authorization: Bearer $LINGUA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name": "Quickstart", "source_locale": "en-US", "target_locales": ["he-IL"]}'
```

The response contains the project ID. Save it:

```bash
export PROJECT_ID="prj_8f2a1c"
```

## Step 3: Upload the source file

```bash
curl -s https://api.lingua.example/v2/projects/$PROJECT_ID/files \
  -H "Authorization: Bearer $LINGUA_API_KEY" \
  -F "file=@en.json" \
  -F "format=json-icu"
```

**Check:** the response shows `"string_count": 3`. If it shows `0`, the format value doesn't match
the file. See [Troubleshooting imports](troubleshooting.md).

## Step 4: Start a translation job

```bash
curl -s https://api.lingua.example/v2/projects/$PROJECT_ID/jobs \
  -H "Authorization: Bearer $LINGUA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"target_locales": ["he-IL"], "workflow": "machine-plus-review"}'
```

Save the returned job ID as `JOB_ID`, then poll its status:

```bash
curl -s https://api.lingua.example/v2/jobs/$JOB_ID \
  -H "Authorization: Bearer $LINGUA_API_KEY"
```

The job moves through `queued`, `translating`, `in_review` and `completed`. In the sandbox
environment, review completes automatically within two minutes.

## Step 5: Download the translation

```bash
curl -s "https://api.lingua.example/v2/projects/$PROJECT_ID/files/en.json/download?locale=he-IL" \
  -H "Authorization: Bearer $LINGUA_API_KEY" \
  -o he.json
```

Open `he.json`. The keys are unchanged, and the placeholders `{name}` and `{count}` are preserved:

```json title="he.json"
{
  "greeting": "ברוך שובך, {name}!",
  "cart.empty": "העגלה שלך ריקה.",
  "cart.items": "{count, plural, one {פריט אחד} other {# פריטים}}"
}
```

## Next steps

- Display the Hebrew file correctly in your UI: [Right-to-left text](rtl-guide.md).
- Reduce cost on future updates: [Translation memory leverage](translation-memory.md).
- Automate this flow: [REST API reference](api-reference.md).
