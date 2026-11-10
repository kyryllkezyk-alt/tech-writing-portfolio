# Display right-to-left translations correctly

This guide shows how to render Hebrew and Arabic strings from Lingua in a web UI without broken
punctuation, reversed numbers or misplaced icons.

**Applies to:** web front ends using HTML and CSS. Mobile platforms follow the same principles with
platform-specific APIs.

## Before you start

- You have a translated file for an RTL locale (`he-IL`, `ar-SA`, `fa-IR`, `ur-PK`).
- Your app sets the locale before first render.

## 1. Set direction at the document level

Set `dir` and `lang` on the root element, not on individual components:

```html
<html lang="he" dir="rtl">
```

Setting direction high in the tree lets the browser's bidirectional algorithm do most of the work.
Setting it per component creates mixed-direction islands that are hard to debug.

## 2. Use logical CSS properties

Replace physical properties with logical ones so layout mirrors automatically:

| Instead of | Use |
| --- | --- |
| `margin-left` | `margin-inline-start` |
| `padding-right` | `padding-inline-end` |
| `text-align: left` | `text-align: start` |
| `left: 0` | `inset-inline-start: 0` |
| `border-left` | `border-inline-start` |

## 3. Isolate user-generated and embedded content

When a string mixes directions, such as a Hebrew sentence with an English product name or a
username, wrap the embedded value in `<bdi>`:

```html
<p>ההזמנה של <bdi>{username}</bdi> נשלחה.</p>
```

Without isolation, a username that ends in a number or punctuation can jump to the wrong side of
the sentence.

## 4. Decide which icons mirror

| Mirror | Don't mirror |
| --- | --- |
| Back and forward arrows | Media play and pause |
| Progress direction | Checkmarks |
| List bullets and indentation | Logos and brand marks |
| Text-alignment icons | Clocks, which always run clockwise |

Mirror with CSS only where needed:

```css
[dir="rtl"] .icon-directional { transform: scaleX(-1); }
```

## 5. Keep numbers, phone numbers and code left-to-right

Numbers already render left-to-right inside RTL text. Phone numbers, version strings and code
fragments don't always, because of the separators between digits. Isolate them:

```html
<span dir="ltr">+972-4-555-0123</span>
```

## Verify

Check these cases on every RTL release:

- [ ] A sentence that ends with an English word followed by a period
- [ ] A username that ends in a digit
- [ ] A price with a currency symbol
- [ ] A truncated string with an ellipsis
- [ ] Back navigation points right

!!! tip "Test before translation arrives"
    Use pseudo-localization with an RTL pseudo-locale to find layout problems before real
    translations exist.

## Related

- [Style guide: writing for translation](../standards/style-guide.md#writing-for-translation)
- [Quickstart](quickstart.md)
