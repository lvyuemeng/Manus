#import "_common.typ": extract-document, figure-view, heading-view, make-eq-numbering, present

#let _title-element = title

#let daily-en(
  title: none,
  authors: (),
  abstract: none,
  keywords: none,
  body,
  ..style,
) = {
  assert(style.pos().len() == 0, message: "daily-en accepts named style values only")
  let doc = extract-document(
    (lang: "en"),
    "en",
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
  set std.bibliography(style: "springer-mathphys", title: [References])

  if present(doc.title) or doc.visible-authors.len() > 0 {
    align(center, {
      if present(doc.title) {
        show _title-element: set text(size: 2.2em, weight: "bold")
        _title-element(doc.title)
      }
      if present(doc.title) and doc.visible-authors.len() > 0 { v(25pt, weak: true) }
      for (index, author) in doc.visible-authors.enumerate() {
        let name = author.at("name", default: none)
        let addition = author.at("addition", default: none)
        if present(name) { text(size: cfg.footnote-size, name) }
        if present(name) and present(addition) { v(8pt, weak: true) }
        if present(addition) { text(size: cfg.footnote-size, addition) }
        if index + 1 < doc.visible-authors.len() { v(8pt, weak: true) }
      }
    })
  }
  set par(spacing: 1.2em, first-line-indent: 1.2em, justify: true, leading: 0.8em)
  if present(doc.abstract) {
    v(20pt, weak: true)
    pad(x: 35pt, {
      align(center, text(1.2em, weight: "bold", "Abstract"))
      v(6pt, weak: true)
      set par(first-line-indent: 0em)
      doc.abstract
    })
  }
  if present(doc.keywords) {
    v(12pt, weak: true)
    pad(x: 35pt, {
      set text(cfg.script-size)
      smallcaps[Keywords: ]
      doc.keywords.join("; ")
    })
  }
  v(15pt, weak: true)
  doc.body
}
