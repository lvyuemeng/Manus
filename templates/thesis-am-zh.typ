#import "../deps.typ": zh
#import "../core.typ": *

#let title-size = zh(3)
#let normal-size = zh(-4)
#let script-size = zh(5)

#let base-styles = (
  // text
  lang: "zh",
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
  head-numbering: "1",
  head1-size: zh(4),
  // math
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
  // fig
  fig-gap: 17pt,
)

#let tmpl = args => {
  let cfg = resolve-config(base-styles, args)
  config-store.update(cfg)

  show: with-page-style.with(cfg)
  show: with-text-style.with(cfg)
  show: with-math-style.with(cfg)
  show: with-heading-style.with(cfg)
  show: with-figure-style.with(cfg)

  set std.bibliography(style: "../bib/science-foundation-in-china.csl", title: [参考文献])
  show cite.where(style: auto): it => {
    if it.supplement != none {
      let (key, ..args) = it.fields()
      cite(it.key, ..args, style: "../bib/cite-zh.csl")
    } else {
      it
    }
  }

  align(center, {
    set par(leading: 1.5em)
    text(size: title-size, font: "SimHei", args.title)
    v(1.5em, weak: true)
    for author in args.authors {
      if "name" in author {
        text(size: normal-size, author.name)
      }
      v(1.5em, weak: true)
      if "addition" in author {
        text(size: normal-size, author.addition)
      }
    }
  })

  set par(spacing: 1em, first-line-indent: (amount: 2em, all: true), justify: true, leading: 1.5em)

  if args.abstract != none {
    v(20pt, weak: true)
    show: pad.with(x: 35pt)
    text(size: script-size, font: "SimHei", "摘要: ")
    text(size: script-size, font: "SimSun", args.abstract)
  }

  if args.keywords != none {
    v(20pt, weak: true)
    show: pad.with(x: 35pt)
    text(size: script-size, font: "SimHei", "关键词： ")
    text(size: script-size, font: "SimSun", args.keywords.join("; "))
  }

  args.body
}
