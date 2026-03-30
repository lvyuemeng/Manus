// ==================================================
// templates/thesis-cp-zh.typ
// Undergraduate / postgraduate thesis — Chinese (XJNU style)
// ==================================================

#import "../core.typ": *
#import "../deps.typ": show-cn-fakebold, zh
#import "../utils.typ": field-theme, mask-field

// Standard Chinese academic type sizes
#let _title-size  = zh(-2)   // 小二 — used for cover heading & info grid
#let _head-size   = zh(3)    // 三号 — abstract heading
#let _normal-size = zh(-4)   // 小四 — body text
#let _script-size = zh(5)    // 五号 — keywords

#let base-styles = (
  lang: "zh",
  fonts: (
    main: "Times New Roman",
    cjk:  "SimSun",
    head: ("Times New Roman", "SimHei"),
  ),
  normal-size:    _normal-size,
  script-size:    _script-size,
  paper:          "a4",
  margin:         (top: 2.54cm, bottom: 2.54cm, left: 3.17cm, right: 3.17cm),
  head-numbering: "1.1",
  head1-size:     _head-size,
  head2-size:     _head-size,
  head-size:      _head-size,
  eq-numbering:   "(1.1)",
  eq-chapterwise: true,
  fig-gap:        17pt,
)

// --------------------------------------------------
// Cover page
// --------------------------------------------------
#let cover(
  title:      (),
  author:     "",
  student-id: "",
  department: "",
  anonymous:  false,
  fonts: (
    title: ("Times New Roman", "KaiTi"),
    label: ("Times New Roman", "SimSun"),
    value: ("Times New Roman", "KaiTi"),
  ),
) = {
  // Apply masking when compiling anonymous copies.
  let a = mask-field(author,     anonymous)
  let s = mask-field(student-id, anonymous)
  let d = mask-field(department, anonymous)

  // Column widths derived from the title font size so the
  // grid scales naturally if the size is changed.
  let label-w = _title-size * 5
  let value-w = _title-size * 10

  let theme = field-theme(
    font-label:   fonts.label,
    size-label:   _title-size,
    weight-label: "bold",
    font-value:   fonts.value,
    size-value:   _title-size,
  )

  show: show-cn-fakebold
  set align(center + horizon)
  set text(size: _title-size, font: fonts.title, weight: "bold")

  // Title — plain content or (zh: …, en: …) dict.
  if type(title) == dictionary {
    par(leading: 1.5em, {
      if "zh" in title { [题目：]; title.zh; linebreak() }
      if "en" in title { [Title: ]; title.en }
    })
  } else {
    par(title)
  }

  v(4em)

  block(width: label-w + value-w)[
    #grid(
      columns: (label-w, value-w),
      column-gutter: 0pt,
      row-gutter:    _title-size,
      ..theme.row("院系名称：", d),
      ..theme.row("学生姓名：", a),
      ..theme.row("学生学号：", s),
    )
  ]
}

// --------------------------------------------------
// Abstract page
// --------------------------------------------------
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

  align(center, text(font: fonts.label, size: _head-size, weight: "bold", "摘  要"))
  v(1em)

  {
    set par(leading: 1.5em, first-line-indent: 2em)
    text(font: fonts.value, size: _normal-size, body)
  }

  let kws = if keywords == none { () } else { keywords }
  if kws.len() > 0 {
    v(1em)
    text(font: fonts.label, size: _normal-size, weight: "bold", "关键词：")
    text(font: fonts.value, size: _normal-size, kws.join("；"))
  }
}

// --------------------------------------------------
// Template entry point
// --------------------------------------------------
#let tmpl = args => {
  let cfg = resolve-config(base-styles, args)
  config-store.update(cfg)

  set std.bibliography(style: "../bib/bib-xjnu.csl", title: [参考文献])
  show cite.where(style: auto): it => {
    if it.supplement != none {
      let (key, ..rest) = it.fields()
      cite(it.key, ..rest, style: "../bib/cite-zh.csl")
    } else {
      it
    }
  }

  show: show-cn-fakebold

  // Thesis expects a single author.
  let auth = cfg.authors.at(0, default: (:))
  cover(
    title:      cfg.title,
    author:     auth.at("name",       default: ""),
    student-id: auth.at("student-id", default: ""),
    department: auth.at("department", default: ""),
  )
  pagebreak()

  abstract(cfg.abstract, keywords: cfg.at("keywords", default: ()))
  pagebreak()

  show: with-page-style.with(cfg)
  show: with-text-style.with(cfg)
  show: with-math-style.with(cfg)
  show: with-heading-style.with(cfg)
  show: with-figure-style.with(cfg)

  set par(justify: true, leading: 1.5em, spacing: 1em, first-line-indent: 2em)

  args.body
}
