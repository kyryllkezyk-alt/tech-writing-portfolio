# How translation memory leverage works

Translation memory (TM) is the reason the second release of a product costs far less to translate
than the first. This page explains what TM stores, how Lingua matches against it, and what that
means for budget and quality decisions.

## What translation memory is

A translation memory is a database of **segments**, usually sentences, paired with their approved
translations. Every time a reviewer approves a translation, Lingua stores the pair in the project's
memory.

When new source text arrives, Lingua compares each segment with the memory before any translator
sees it.

## Match types

| Match | What it means | Typical effort |
| --- | --- | --- |
| **Context match (101%)** | Same text, same key, same surrounding segments | None. Reused automatically |
| **Exact match (100%)** | Same text, different context | Quick check |
| **Fuzzy match (75–99%)** | Similar text; the translator edits the stored translation | Partial |
| **No match (<75%)** | New text | Full translation |

The percentage measures how much editing a translator needs, not how "correct" the old
translation is. A 95% match can still need a meaningful change if the one word that differs is a
negation.

## Why leverage changes your costs

Most vendors price by word and discount matched words. A common scale:

| Match band | Billed at |
| --- | --- |
| Context and exact | 0–25% of the full rate |
| 85–99% | 50–60% |
| 75–84% | 70–80% |
| New | 100% |

So the source text you write today sets the cost of every future release. Two writers who express
the same idea in different words create two new segments instead of one reused segment.

## How writers increase leverage

- **Reuse approved wording.** Write "Select **Save**" everywhere, not "Click Save" in one place and
  "Press the Save button" in another.
- **Keep sentences independent.** A sentence that depends on the previous one for meaning can't be
  reused safely.
- **Don't build sentences from fragments.** Concatenated strings never match and often can't be
  translated grammatically.

These rules are part of the [style guide](../standards/style-guide.md#writing-for-translation).

## What TM doesn't do

- It doesn't check whether a stored translation was good. Bad approvals propagate.
- It doesn't understand meaning. "Close" the verb and "close" the adjective match each other.
- It doesn't replace terminology management. See [Terminology policy](../standards/terminology.md).
