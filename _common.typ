#let present(value) = value != none and not (
  (type(value) == str or type(value) == array or type(value) == dictionary)
    and value.len() == 0
)

#let deep-merge(base, over) = {
  let result = base
  for (key, value) in over {
    result.insert(key, if key in result
      and type(result.at(key)) == dictionary
      and type(value) == dictionary {
        deep-merge(result.at(key), value)
      } else {
        value
      })
  }
  result
}

#let shared-defaults = (
  lang: "en",
  fonts: (
    main: "Libertinus Serif",
    cjk: "Microsoft YaHei",
    head: "Libertinus Serif",
    math: "New Computer Modern Math",
    math-latin: "Libertinus Serif",
  ),
  script-size: 7.97224pt,
  footnote-size: 8.50012pt,
  normal-size: 10.00002pt,
  paper: "a4",
  margin: (top: 117pt, left: 118pt, right: 119pt, bottom: 96pt),
  header: none,
  head-numbering: "1.1",
  head-supplement: [Section],
  head1-size: 1.4em,
  head2-size: 1.2em,
  head-size: 1.2em,
  head1-spacing: 0.8em,
  head2-spacing: 0.6em,
  head-spacing: 0.4em,
  head1-above: 1.8em,
  head-above: 1.2em,
  head-below: 1em,
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
  eq-above: 1.2em,
  eq-below: 1.2em,
  fig-gap: 17pt,
  fig-padding: 23pt,
)

#let extract-document(
  defaults,
  preferred-language,
  title: none,
  authors: (),
  abstract: none,
  keywords: none,
  body: none,
  style: (:),
) = {
  let cfg = deep-merge(deep-merge(shared-defaults, defaults), style)
  let titles = if type(title) == dictionary {
    title.values().filter(present)
  } else if present(title) {
    (title,)
  } else {
    ()
  }
  let selected = if (
    type(title) == dictionary
    and preferred-language in title
    and present(title.at(preferred-language))
  ) {
      title.at(preferred-language)
    } else if titles.len() > 0 {
      titles.first()
    } else {
      none
    }
  let admitted = authors.filter(author => type(author) == dictionary)
  let visible = admitted.filter(author =>
    present(author.at("name", default: none)) or
    present(author.at("addition", default: none)))
  let metadata = admitted
    .filter(author => type(author.at("name", default: none)) == str
      and present(author.name))
    .map(author => author.name)
  (
    cfg: cfg,
    title: selected,
    titles: titles,
    authors: admitted,
    visible-authors: visible,
    metadata-authors: metadata,
    abstract: abstract,
    keywords: keywords,
    body: body,
  )
}

#let make-eq-numbering(format, chapterwise) = if chapterwise {
  (..numbers) => numbering(
    format,
    counter(heading).get().first(),
    numbers.pos().first(),
  )
} else {
  format
}

#let heading-body(cfg, it) = {
  if it.numbering != none {
    if it.level == 1 and it.supplement != cfg.head-supplement {
      it.supplement
      [ ]
      counter(heading).display(it.numbering)
      [:]
    } else {
      counter(heading).display(it.numbering)
    }
    h(0.3em)
  }
  it.body
}

#let heading-view(cfg, it) = {
  let size = if it.level == 1 { cfg.head1-size }
    else if it.level == 2 { cfg.head2-size }
    else { cfg.head-size }
  let spacing = if it.level == 1 { cfg.head1-spacing }
    else if it.level == 2 { cfg.head2-spacing }
    else { cfg.head-spacing }
  let above = if it.level <= 2 { cfg.head1-above } else { cfg.head-above }
  block(sticky: true, above: above, below: cfg.head-below)[
    #set align(left)
    #set text(font: cfg.fonts.head, lang: cfg.lang, weight: "bold", size: size)
    #set par(spacing: spacing, first-line-indent: 0em)
    #heading-body(cfg, it)
  ]
}

#let figure-view(cfg, it) = {
  show figure.caption: caption => {
    set par(justify: true)
    caption.supplement
    if caption.numbering != none {
      [ ]
      numbering(caption.numbering, ..caption.counter.at(it.location()))
    }
    [. ]
    caption.body
  }
  show selector.or(table, image): pad.with(x: cfg.fig-padding)
  it
}
