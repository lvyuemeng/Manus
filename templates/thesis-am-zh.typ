// ==================================================
// templates/thesis-am-zh.typ
// Chinese academic journal article
// ==================================================

#import "../core.typ": *
#import "../deps.typ": zh

#let base-styles = (
  lang: "zh",
  fonts: (
    main: "Times New Roman",
    cjk:  "SimSun",
    head: ("Times New Roman", "SimHei"),
  ),
  normal-size:    zh(-4),   // 小四
  script-size:    zh(5),    // 五号
  paper:          "a4",
  head-numbering: "1",
  head1-size:     zh(4),    // 四号
  eq-numbering:   "(1.1)",
  eq-chapterwise: true,
  fig-gap:        17pt,
)

#let tmpl = args => {
  let cfg = resolve-config(base-styles, args)
  config-store.update(cfg)

  show: with-page-style.with(cfg)
  show: with-text-style.with(cfg)
  show: with-math-style.with(cfg)
  show: with-heading-style.with(cfg)
  show: with-figure-style.with(cfg)

  set std.bibliography(
    style: "../bib/science-foundation-in-china.csl",
    title: [参考文献],
  )
  show cite.where(style: auto): it => {
    if it.supplement != none {
      let (key, ..rest) = it.fields()
      cite(it.key, ..rest, style: "../bib/cite-zh.csl")
    } else {
      it
    }
  }

  // ── Title ───────────────────────────────────────
  align(center, {
    text(size: zh(3), font: "SimHei", weight: "bold", args.title)
    v(1.5em, weak: true)

    // ── Authors — one block per author ────────────
    for author in args.authors {
      if "name"     in author {
        par(text(size: cfg.normal-size, font: "SimSun", author.name))
      }
      if "addition" in author {
        par(text(size: cfg.script-size, font: "SimSun", author.addition))
      }
      v(0.8em, weak: true)
    }
  })

  set par(
    spacing:           1em,
    first-line-indent: (amount: 2em, all: true),
    justify:           true,
    leading:           1.5em,
  )

  // ── Abstract ────────────────────────────────────
  // Use pad() directly — `show: pad.with(...)` inside an `if` block
  // leaks the set rule to all following content including args.body.
  let abstract = args.at("abstract", default: none)
  if abstract != none {
    v(20pt, weak: true)
    pad(x: 35pt, {
      text(size: cfg.script-size, font: "SimHei", weight: "bold", "摘要：")
      text(size: cfg.script-size, font: "SimSun", abstract)
    })
  }

  // ── Keywords ────────────────────────────────────
  let keywords = args.at("keywords", default: none)
  if keywords != none and keywords.len() > 0 {
    v(10pt, weak: true)
    pad(x: 35pt, {
      text(size: cfg.script-size, font: "SimHei", weight: "bold", "关键词：")
      text(size: cfg.script-size, font: "SimSun", keywords.join("；"))
    })
  }

  args.body
}
