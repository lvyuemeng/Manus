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

  show: with-page-style.with(cfg)
  show: with-text-style.with(cfg)
  show: with-math-style.with(cfg)
  show: with-heading-style.with(cfg)
  show: with-figure-style.with(cfg)

  set std.bibliography(style: "springer-mathphys", title: [References])

  // ── Title ───────────────────────────────────────
  align(center, {
    // Accepts plain content or a (zh: …, en: …) dict.
    if type(args.title) == dictionary {
      set text(size: 2.2em, weight: "bold")
      if "zh" in args.title { par(args.title.zh) }
      if "en" in args.title { par(args.title.en) }
    } else {
      text(size: 2.2em, weight: "bold", args.title)
    }

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
