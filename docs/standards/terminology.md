# Terminology policy

Consistent terms make documentation easier to read, cheaper to translate, and easier to search.
This policy explains how terms are approved, stored and enforced.

## Principles

- **One concept, one term.** Synonyms are banned in product text.
- **The glossary is the source of truth.** If a term isn't in the glossary, it's a proposal.
- **Every term has a definition and a "don't use" list.**

## Glossary entry format

| Field | Example |
| --- | --- |
| Term | translation memory |
| Definition | A database of approved source–target segment pairs reused in later jobs |
| Part of speech | noun |
| Don't use | TM database, translation cache, memory bank |
| Capitalization | lowercase in running text |
| Translate? | yes; see locale glossaries |
| Notes | Abbreviate as *TM* only after the first use on a page |

## Lifecycle

1. **Propose.** Anyone opens a pull request adding the term with status `proposed`.
2. **Review.** The docs lead and one product owner approve or reject within five working days.
3. **Approve.** Status becomes `approved`. Translators receive the term in the next glossary sync.
4. **Deprecate.** Replaced terms keep their entry with status `deprecated` and a pointer to the
   replacement, so old content can be found and fixed.

## Enforcement

Terminology rules are machine-checked, not left to memory:

- **Docs:** the `accept.txt` and `reject.txt` vocabularies in this repository feed Vale, which runs
  on every pull request. A rejected term fails the check.
- **Translation:** approved terms are exported to TBX and loaded into the CAT tool, where
  translators see them as they work and QA flags deviations.

## Locale glossaries

Each target locale has its own glossary owned by its lead linguist. A source term can't be approved
until the high-priority locales have proposed a translation, because a term that can't be
translated well is a bad source term.
