#import "../core.typ": *
#import "../deps.typ": components as comp, kouhu, show-cn-fakebold, utils, zh

// KaiTi/SimSun/SimHei
#let title-size = zh(-2)
#let head-size = zh(3)
#let normal-size = zh(-4)
#let script-size = zh(5)
#let label-size = title-size * 5
#let val-size = title-size * 10

#let base-styles = (
  // text
  lang: "en",
  fonts: (
    main: "Times New Roman",
    cjk: "SimSun",
    head: ("Times New Roman", "SimHei"),
  ),
  normal-size: normal-size,
  script-size: script-size,
  // page
  paper: "a4",
  // heading
  head-numbering: "1.1",
  head1-size: head-size,
  head2-size: head-size,
  head-size: head-size,
  // math
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
  // fig
  fig-gap: 17pt,
)

#let cover(
  title: (),
  author: "",
  student-id: "",
  department: "",
  fonts: (
    title: ("Times New Roman", "KaiTi"),
    label: ("Times New Roman", "SimSun"),
    value: ("Times New Roman", "KaiTi"),
  ),
) = {
  let theme = comp.field-theme(
    font-label: fonts.label,
    font-value: fonts.value,
    size-label: title-size,
    size-value: title-size,
  )

  show: show-cn-fakebold
  set align(center + horizon)
  set text(size: title-size, font: fonts.title, weight: "bold")

  if type(title) == dictionary {
    par([
      题目：#title.zh
    ])
    par([
      Title: #title.en
    ])
  } else {
    title
  }

  v(4em)

  block(width: 320pt)[
    #grid(
      columns: (label-size, val-size),
      column-gutter: 0pt,
      row-gutter: title-size,
      ..(theme.row)("院系名称：", department),
      ..(theme.row)("学生姓名：", author),
      ..(theme.row)("学生学号：", student-id)
    )
  ]
}

#let abstract(
  body,
  keywords: (),
  fonts: (
    label: ("Times New Roman", "SimHei"),
    value: ("Times New Roman", "SimSun"),
  ),
) = {
  show: show-cn-fakebold
  set par(justify: true)

  align(center, {
    text(font: fonts.label, size: head-size, weight: "bold", "摘  要")
  })

  v(1em)

  {
    set par(leading: 1.5em, first-line-indent: 2em)
    text(font: fonts.value, size: normal-size, body)
  }

  v(1em)

  if keywords != none {
    set text(size: normal-size)
    text(font: fonts.label, "关键词： ", weight: "bold")
    let keywords = utils.join-by-sep(keywords, separator: "，")
    text(font: fonts.value, keywords)
  }
}

#let tmpl = args => {
  let cfg = resolve-config(base-styles, args)
  config-store.update(cfg)

  set std.bibliography(style: "../bib/bib-xjnu.csl", title: [参考文献])
  show cite.where(style: auto): it => {
    if it.supplement != none {
      let (key, ..args) = it.fields()
      cite(it.key, ..args, style: "../bib/cite-zh.csl")
    } else {
      it
    }
  }

  show: show-cn-fakebold

  // Single author
  let author = cfg.authors.at(0).name
  let department = cfg.authors.at(0).department
  let student-id = cfg.authors.at(0).student-id
  cover(author: author, department: department, student-id: student-id, title: cfg.title)
  pagebreak()
  abstract(cfg.abstract, keywords: cfg.keywords)
  pagebreak()

  show: with-page-style.with(cfg)
  show: with-text-style.with(cfg)
  show: with-math-style.with(cfg)
  show: with-heading-style.with(cfg)
  show: with-figure-style.with(cfg)

  set par(justify: true, leading: 1.5em, spacing: 1em, first-line-indent: 2em)
  //
  args.body
}

#cover(title: (en: lorem(8), zh: kouhu(length: 8)), author: kouhu(offset: 5, length: 5))
#pagebreak()
#abstract(kouhu(length: 100), keywords: (kouhu(length: 2), kouhu(offset: 10, length: 3)))
