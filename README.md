# Manus - Typst Templates Interface

A compact collection of Typst templates used to assemble academic documents (daily notes, theses, abstracts) with simple, composable style wrappers.

## Why this repo

- Provides reusable templates and style wrappers so documents share consistent typography and numbering (headings, figures, equations).

- Includes `zh-draft` (a git submodule) with small layout components useful for China-style thesis formatting.

Layout overview
- `mine/` — entrypoint templates and style glue.
  - See [mine/mine.typ](mine/mine.typ) for the template selector and `mine()` entry.
  - Main style composition lives in [mine/core.typ](mine/core.typ).
- `mine/templates/` — pre-built templates: `daily-en`, `thesis-am-zh`, `thesis-cp-zh`.
- `mine/bib/` — CSL styles used for bibliography rendering.

Quick start

1. Clone repository and init submodules:

```bash
git clone <repo> my-docs
# or
git submodule add <repo> <path>
git submodule update --init --recursive
```

2. Render your own document

```typst
#import "mine/mine.typ": *

#let mine(
  template: "daily-en",
  title: none,
  authors: (),
  abstract: none,
  keywords: none,
  body,
  ..extra,
) = {
  let tmpl = select-template(template)

  // apply in dictionary
  tmpl((
    title: title,
    authors: authors,
    abstract: abstract,
    keywords: keywords,
    body: body,
    ..extra.named(),
  ))
}
```

- Example: see [mine/templates/daily-en.typ](templates/daily-en.typ) for a minimal usage pattern.

## Notes & conventions

- Core styling is composed via `with-*` wrappers in [mine/core.typ](mine/core.typ). Prefer composing new behavior with these wrappers rather than editing the core file.
- `config-store` is used to pass runtime configuration into wrappers — consult `resolve-config` in [mine/core.typ](mine/core.typ).
- Keep `#import "@preview/..."` pins intact when editing; they reference preview packages used by the templates.
- Watch relative imports: Typst resolves `#import` paths relative to the importing file.

## Fonts & platform

- The templates set a CJK fallback (`Microsoft YaHei`) by default. On non-Windows machines, replace or document font substitutions in `mine/core.typ`.

## Contributing

- Add small focused changes: new templates go in `mine/templates/` and must be registered in [mine/mine.typ](mine/mine.typ) via `select-template`.
- For component additions, prefer adding helpers in `zh-draft/` and keeping `mine/` as the assembly layer.

## License

- This repository is licensed under the MIT License — see `LICENSE`.