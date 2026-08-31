// ==================================================
// templates/daily-en.typ
// Generic English document (article / report)
// ==================================================

#import "../core.typ": *

#let base-styles = (
  lang: "en",
)

#let tmpl = args => {
  let cfg = resolve-config(base-styles, args)
  config-store.update(cfg)

  let title-body = if type(args.title) == dictionary {
    if "en" in args.title { args.title.en }
    else { args.title.values().first() }
  } else {
    args.title
  }
  let metadata-authors = args.authors
    .filter(author => "name" in author and type(author.name) == str)
    .map(author => author.name)

  set document(title: title-body)
  if metadata-authors.len() > 0 { set document(author: metadata-authors) }
  if args.abstract != none { set document(description: args.abstract) }
  if args.keywords != none { set document(keywords: args.keywords) }

  show: with-page-style.with(cfg)
  show: with-text-style.with(cfg)
  show: with-math-style.with(cfg)
  show: with-heading-style.with(cfg)
  show: with-figure-style.with(cfg)

  set std.bibliography(style: "springer-mathphys", title: [References])

  // ── Title ───────────────────────────────────────
  align(center, {
    show title: set text(size: 2.2em, weight: "bold")
    title(title-body)

    v(25pt, weak: true)

    // ── Authors ─────────────────────────────────
    for author in args.authors {
      if "name"     in author { text(size: cfg.footnote-size, author.name)     }
      v(8pt, weak: true)
      if "addition" in author { text(size: cfg.footnote-size, author.addition) }
    }
  })

  set par(spacing: 1.2em, first-line-indent: 1.2em, justify: true, leading: 0.8em)

  // ── Abstract ────────────────────────────────────
  // Use pad() directly instead of `show: pad.with(...)` to avoid
  // the set-rule leaking to args.body and all following content.
  let abstract = args.at("abstract", default: none)
  if abstract != none {
    v(20pt, weak: true)
    pad(x: 35pt, {
      align(center, text(1.2em, weight: "bold", "Abstract"))
      v(6pt, weak: true)
      set par(first-line-indent: 0em)
      abstract
    })
  }

  // ── Keywords ────────────────────────────────────
  let keywords = args.at("keywords", default: none)
  if keywords != none and keywords.len() > 0 {
    v(12pt, weak: true)
    pad(x: 35pt, {
      set text(cfg.script-size)
      smallcaps[Keywords: ]
      keywords.join("; ")
    })
  }

  v(15pt, weak: true)
  args.body
}
