#import "@preview/cuti:0.4.0": show-cn-fakebold
#import "@preview/pointless-size:0.1.2": zh
#import "_common.typ": extract-document, figure-view, heading-view, make-eq-numbering, present

#let _title-size = zh(-2)
#let _head-size = zh(3)
#let _normal-size = zh(-4)
#let _script-size = zh(5)

#let _mask(value, anonymous, length: 5) = if anonymous {
  range(length).map(_ => "█").join()
} else {
  value
}

#let _cover-row(label, value, fonts) = (
  grid.cell(rect(
    width: 100%,
    stroke: none,
    text(font: fonts.label, size: _title-size, weight: "bold", label),
  )),
  grid.cell(rect(
    width: 100%,
    stroke: (bottom: 0.5pt + black),
    text(font: fonts.value, size: _title-size, value),
  )),
)

#let _cover(
  title: none,
  author: none,
  student-id: none,
  department: none,
  anonymous: false,
  fonts: (
    title: ("Times New Roman", "KaiTi"),
    label: ("Times New Roman", "SimSun"),
    value: ("Times New Roman", "KaiTi"),
  ),
) = {
  let author = if present(author) { _mask(author, anonymous) } else { none }
  let student-id = if present(student-id) { _mask(student-id, anonymous) } else { none }
  let department = if present(department) { _mask(department, anonymous) } else { none }
  let has-title = if type(title) == dictionary {
    title.values().any(present)
  } else {
    present(title)
  }
  show: show-cn-fakebold
  set align(center + horizon)
  set text(size: _title-size, font: fonts.title, weight: "bold")
  if has-title and type(title) == dictionary {
    par(leading: 1.5em, {
      if "zh" in title and present(title.zh) { [题目：]; title.zh; linebreak() }
      if "en" in title and present(title.en) { [Title: ]; title.en }
    })
  } else if has-title {
    par(title)
  }
  let rows = ()
  if present(department) { rows += _cover-row("院系名称：", department, fonts) }
  if present(author) { rows += _cover-row("学生姓名：", author, fonts) }
  if present(student-id) { rows += _cover-row("学生学号：", student-id, fonts) }
  if rows.len() > 0 {
    if has-title { v(4em) }
    block(width: _title-size * 15)[
      #grid(
        columns: (_title-size * 5, _title-size * 10),
        column-gutter: 0pt,
        row-gutter: _title-size,
        ..rows,
      )
    ]
  }
}

#let _abstract-page(
  body,
  keywords: (),
  fonts: (
    label: ("Times New Roman", "SimHei"),
    value: ("Times New Roman", "SimSun"),
  ),
) = {
  show: show-cn-fakebold
  set par(justify: true)
  if present(body) {
    align(center, text(font: fonts.label, size: _head-size, weight: "bold", "摘  要"))
    v(1em)
    {
      set par(leading: 1.5em, first-line-indent: 2em)
      text(font: fonts.value, size: _normal-size, body)
    }
  }
  let keywords = if keywords == none { () } else { keywords }
  if keywords.len() > 0 {
    if present(body) { v(1em) }
    text(font: fonts.label, size: _normal-size, weight: "bold", "关键词：")
    text(font: fonts.value, size: _normal-size, keywords.join("；"))
  }
}

#let cp-zh(
  title: none,
  authors: (),
  abstract: none,
  keywords: none,
  anonymous: false,
  body,
  ..style,
) = {
  assert(style.pos().len() == 0, message: "cp-zh accepts named style values only")
  let defaults = (
    lang: "zh",
    fonts: (
      main: "Times New Roman",
      cjk: "SimSun",
      head: ("Times New Roman", "SimHei"),
    ),
    normal-size: _normal-size,
    script-size: _script-size,
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, left: 3.17cm, right: 3.17cm),
    head-numbering: "1.1",
    head-supplement: [小节],
    head1-size: _head-size,
    head2-size: _head-size,
    head-size: _head-size,
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
  let author = doc.authors.at(0, default: (:))
  if present(doc.title) { set document(title: doc.title) }
  if doc.metadata-authors.len() > 0 { set document(author: doc.metadata-authors) }
  if present(doc.abstract) { set document(description: doc.abstract) }
  if present(doc.keywords) { set document(keywords: doc.keywords) }

  set std.bibliography(style: "bib/bib-xjnu.csl", title: [参考文献])
  show cite.where(style: auto): it => if it.supplement != none {
    let (key, ..rest) = it.fields()
    cite(it.key, ..rest, style: "bib/cite-zh.csl")
  } else {
    it
  }
  show: show-cn-fakebold
  let has-cover = present(doc.title) or (
    present(author.at("name", default: none)) or
    present(author.at("student-id", default: none)) or
    present(author.at("department", default: none))
  )
  if has-cover {
    _cover(
      title: title,
      author: author.at("name", default: none),
      student-id: author.at("student-id", default: none),
      department: author.at("department", default: none),
      anonymous: anonymous,
    )
    pagebreak()
  }
  if present(doc.abstract) or present(doc.keywords) {
    _abstract-page(doc.abstract, keywords: doc.keywords)
    pagebreak()
  }

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
  set par(justify: true, leading: 1.5em, spacing: 1em, first-line-indent: 2em)
  doc.body
}
