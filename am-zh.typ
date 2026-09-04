#import "@preview/pointless-size:0.1.2": zh
#import "_common.typ": extract-document, figure-view, heading-view, make-eq-numbering, present

#let am-zh(
  title: none,
  authors: (),
  abstract: none,
  keywords: none,
  body,
  ..style,
) = {
  assert(style.pos().len() == 0, message: "am-zh accepts named style values only")
  let defaults = (
    lang: "zh",
    fonts: (
      main: "Times New Roman",
      cjk: "SimSun",
      head: ("Times New Roman", "SimHei"),
    ),
    normal-size: zh(-4),
    script-size: zh(5),
    paper: "a4",
    head-numbering: "1",
    head-supplement: [小节],
    head1-size: zh(4),
    eq-numbering: "(1.1)",
    eq-chapterwise: true,
    fig-gap: 17pt,
  )
  let doc = extract-document(
    defaults,
    "zh",
    title: title,
    authors: authors,
    abstract: abstract,
    keywords: keywords,
    body: body,
    style: style.named(),
  )
  let cfg = doc.cfg
  if present(doc.title) { set document(title: doc.title) }
  if doc.metadata-authors.len() > 0 { set document(author: doc.metadata-authors) }
  if present(doc.abstract) { set document(description: doc.abstract) }
  if present(doc.keywords) { set document(keywords: doc.keywords) }

  set page(
    paper: cfg.paper,
    margin: cfg.margin,
    header-ascent: 14pt,
    header: cfg.header,
    footer-descent: 14pt,
    footer: context align(center, text(
      size: cfg.script-size,
      str(counter(page).get().first()),
    )),
  )
  set text(
    font: ((name: cfg.fonts.main, covers: "latin-in-cjk"), cfg.fonts.cjk),
    size: cfg.normal-size,
    lang: cfg.lang,
  )
  set math.equation(numbering: make-eq-numbering(cfg.eq-numbering, cfg.eq-chapterwise))
  show math.equation: set text(font: (
    (name: cfg.fonts.math-latin, covers: regex("\p{Latin}")),
    cfg.fonts.math,
  ))
  show math.equation: set block(above: cfg.eq-above, below: cfg.eq-below)
  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  set heading(numbering: cfg.head-numbering, supplement: cfg.head-supplement)
  show heading: it => heading-view(cfg, it)
  set figure(gap: cfg.fig-gap)
  show figure: it => figure-view(cfg, it)
  set std.bibliography(style: "bib/science-foundation-in-china.csl", title: [参考文献])
  show cite.where(style: auto): it => if it.supplement != none {
    let (key, ..rest) = it.fields()
    cite(it.key, ..rest, style: "bib/cite-zh.csl")
  } else {
    it
  }

  if present(doc.title) or doc.visible-authors.len() > 0 {
    align(center, {
      if present(doc.title) {
        text(size: zh(3), font: "SimHei", weight: "bold", doc.title)
      }
      if present(doc.title) and doc.visible-authors.len() > 0 { v(1.5em, weak: true) }
      for author in doc.visible-authors {
        let name = author.at("name", default: none)
        let addition = author.at("addition", default: none)
        if present(name) { par(text(size: cfg.normal-size, font: "SimSun", name)) }
        if present(addition) { par(text(size: cfg.script-size, font: "SimSun", addition)) }
        v(0.8em, weak: true)
      }
    })
  }
  set par(
    spacing: 1em,
    first-line-indent: (amount: 2em, all: true),
    justify: true,
    leading: 1.5em,
  )
  if present(doc.abstract) {
    v(20pt, weak: true)
    pad(x: 35pt, {
      text(size: cfg.script-size, font: "SimHei", weight: "bold", "摘要：")
      text(size: cfg.script-size, font: "SimSun", doc.abstract)
    })
  }
  if present(doc.keywords) {
    v(10pt, weak: true)
    pad(x: 35pt, {
      text(size: cfg.script-size, font: "SimHei", weight: "bold", "关键词：")
      text(size: cfg.script-size, font: "SimSun", doc.keywords.join("；"))
    })
  }
  doc.body
}
