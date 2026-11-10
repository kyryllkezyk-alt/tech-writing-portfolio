# Style guide

This guide covers decisions that a general style guide doesn't make for us. For anything not listed
here, follow the [Google developer documentation style guide](https://developers.google.com/style).

## Voice

- Address the reader as **you**. Use **we** only for the organization, and sparingly.
- Use active voice: "Lingua stores the file", not "The file is stored".
- Use present tense: "The API returns", not "The API will return".
- Don't use *simply*, *just*, *easy* or *obviously*. They help no one and insult the reader who is
  stuck.

## Structure

- One page, one reader task or one concept.
- Put prerequisites before the first step.
- Start each step with a verb. One action per step.
- After an action that can fail, say what the reader should see.

## UI and code

| Element | Format | Example |
| --- | --- | --- |
| UI labels | Bold, exact capitalization | Select **Create key** |
| Navigation paths | Bold, `>` separator | **Settings > API keys** |
| Code, values, file names | Code font | `en.json`, `replace=true` |
| Placeholders | Code font, descriptive | `<project_id>` |

## Writing for translation

Most of our readers read a translation. Write source text that translates cleanly.

1. **Keep sentences under 25 words.** Long sentences multiply ambiguity in every language.
2. **Write complete sentences.** Don't drop articles or verbs to save space.
3. **Avoid idioms and wordplay.** "Hit the ground running" has no equivalent in most languages.
4. **Use one term for one concept.** If it's a *project* here, it's a *project* everywhere. See the
   [terminology policy](terminology.md).
5. **Never concatenate strings.** "You have " + n + " items" can't be translated grammatically in
   languages with case or plural forms.
6. **Don't put text in images.** It can't be translated without a designer.
7. **Leave room.** German and Finnish UI text runs 30–40% longer than English.
8. **Avoid ambiguous `-ing` forms.** "Updating files" can be an instruction or a status.

## Numbers and dates

- Use numerals for 10 and above, and for all measurements.
- Write dates as `August 4, 2026` in prose and ISO 8601 in code.
- Don't use dates like `04/08/2026`. Half the world reads them differently.
