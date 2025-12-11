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

  align(center, {
    if type(args.title) == dictionary {
      set text(size: 2.2em, weight: "bold")
      par([
        #args.title.zh
      ])
      par([
        #args.title.en
      ])
    } else {
      text(size: 2.2em, weight: "bold", args.title)
    }
    v(25pt, weak: true)
    for author in args.authors {
      if "name" in author {
        text(size: footnote-size, author.name)
      }
      v(8pt)
      if "addition" in author {
        text(size: footnote-size, author-addition)
      }
    }
  })

  set par(spacing: 1.2em, first-line-indent: 1.2em, justify: true, leading: 0.8em)

  if args.abstract != none {
    v(20pt, weak: true)
    show: pad.with(x: 35pt)
    align(center, text(1.2em, weight: "bold", "Abstract"))
    args.abstract
  }

  if args.keywords != none {
    v(20pt, weak: true)
    show: pad.with(x: 35pt)
    set text(script-size)
    smallcaps("Keywords")
    args.keywords.join("; ")
  }

  v(15pt, weak: true)
  args.body
}
