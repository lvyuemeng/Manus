// ==================================================
// core.typ — config resolution, style applicators, appendix
// ==================================================

#let config-store = state("tmpl-config", (:))

// --------------------------------------------------
// Deep-merge two dicts: sub-dicts merged recursively,
// all other values replaced (second wins).
// --------------------------------------------------
#let deep-merge(base, over) = {
  let result = base
  for (k, v) in over {
    result.insert(k,
      if k in result and type(result.at(k)) == dictionary and type(v) == dictionary {
        deep-merge(result.at(k), v)
      } else {
        v
      }
    )
  }
  result
}

// --------------------------------------------------
// Canonical defaults — every key is available as
// cfg.<key> inside all style applicators and templates.
// --------------------------------------------------
#let core-styles = (
  // ── Text ───────────────────────────────────────
  lang:          "en",
  fonts: (
    main:        "Libertinus Serif",
    cjk:         "Microsoft YaHei",
    head:        "Libertinus Serif",
    math:        "New Computer Modern Math",
    math-latin:  "Libertinus Serif",  // covers \p{Latin} inside math
  ),
  script-size:    7.97224pt,
  footnote-size:  8.50012pt,
  small-size:     9.24994pt,
  normal-size:   10.00002pt,
  // ── Page ───────────────────────────────────────
  paper:  "a4",
  margin: (top: 117pt, left: 118pt, right: 119pt, bottom: 96pt),
  // none      → centred page-number footer, empty header
  // function  → called as header(page-num) => content
  // content   → placed verbatim every page
  header: none,
  // ── Headings ───────────────────────────────────
  head-numbering: "1.1",
  head1-size:     1.4em,
  head2-size:     1.2em,
  head-size:      1.2em,   // level 3+
  head1-spacing:  0.8em,
  head2-spacing:  0.6em,
  head-spacing:   0.4em,   // level 3+
  head1-above:    1.8em,   // v-space above levels 1–2
  head-above:     1.2em,   // v-space above level 3+
  head-below:     1.0em,   // v-space below all levels
  // ── Math ───────────────────────────────────────
  eq-numbering:   "(1.1)",
  eq-chapterwise: true,
  // ── Figures ────────────────────────────────────
  fig-gap:        17pt,
  fig-padding:    23pt,    // horizontal pad on table/image children
)

// Merge: core ← template-base ← user args (deep for sub-dicts).
#let resolve-config(tmpl-base, cfg) = {
  deep-merge(deep-merge(core-styles, tmpl-base), cfg)
}

// ==================================================
// Style applicators — each is (cfg, content) so they
// work directly in `show: f.with(cfg)` chains.
// ==================================================

#let with-text-style(cfg, content) = {
  set text(
    font: ((name: cfg.fonts.main, covers: "latin-in-cjk"), cfg.fonts.cjk),
    size: cfg.normal-size,
    lang: cfg.lang,
  )
  content
}

#let with-page-style(cfg, content) = {
  set page(
    paper:          cfg.paper,
    margin:         cfg.margin,
    header-ascent:  14pt,
    header: context {
      let h = cfg.header
      let i = counter(page).get().first()
      if   type(h) == function { h(i) }
      else if h != none        { h    }
      // none → empty; footer carries the page number
    },
    footer-descent: 14pt,
    footer: context {
      align(center, text(size: cfg.script-size,
                         str(counter(page).get().first())))
    },
  )
  content
}

// --------------------------------------------------
// Headings
// --------------------------------------------------

// Render a heading at `level` with the correct size,
// spacing, and font from cfg.  Takes an int directly so
// callers don't need to pass the full heading element.
#let core-heading(cfg, level, body) = {
  let size    = if level == 1      { cfg.head1-size    }
                else if level == 2 { cfg.head2-size    }
                else               { cfg.head-size     }
  let spacing = if level == 1      { cfg.head1-spacing }
                else if level == 2 { cfg.head2-spacing }
                else               { cfg.head-spacing  }
  let above   = if level <= 2      { cfg.head1-above   }
                else               { cfg.head-above    }

  set align(left)
  set text(font: cfg.fonts.head, lang: cfg.lang, weight: "bold", size: size)
  set par(spacing: spacing, first-line-indent: 0em)
  v(above, weak: true)
  body
  v(cfg.head-below, weak: true)
}

#let _fmt-normal-heading(it) = {
  if it.numbering != none { counter(heading).display(it.numbering); h(0.3em) }
  it.body
}

#let _fmt-appendix-heading(it) = {
  if it.level == 1 and it.numbering != none {
    it.supplement; [ ]; counter(heading).display(); [:]
  } else if it.numbering != none {
    counter(heading).display()
  }
  h(0.3em)
  it.body
}

#let with-heading-style(cfg, content) = {
  set heading(numbering: cfg.head-numbering)
  if "supplement" in cfg { set heading(supplement: cfg.supplement) }
  show heading: it => core-heading(cfg, it.level, _fmt-normal-heading(it))
  content
}

// --------------------------------------------------
// Math
// --------------------------------------------------

// Returns a numbering value for math.equation — either a
// chapterwise closure or the raw format string.
#let _make-eq-numbering(fmt, chapterwise) = {
  if chapterwise {
    (..n) => numbering(fmt, counter(heading).get().first(), n.pos().first())
  } else {
    fmt
  }
}

#let with-math-style(cfg, content) = {
  set math.equation(numbering: _make-eq-numbering(cfg.eq-numbering, cfg.eq-chapterwise))
  show math.equation: set text(font: (
    (name: cfg.fonts.math-latin, covers: regex("\p{Latin}")),
    cfg.fonts.math,
  ))
  show math.equation: set block(above: 2em, below: 2em)
  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  content
}

// --------------------------------------------------
// Figures
// --------------------------------------------------

#let with-figure-style(cfg, content) = {
  set figure(gap: cfg.fig-gap)
  show figure: it => {
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
  content
}

// --------------------------------------------------
// Appendix
// --------------------------------------------------

#let appendix(
  supplement:     "Appendix",
  head-numbering: "A.1",
  eq-numbering:   "(A.1)",
  eq-chapterwise: true,
  reset:          true,
  content,
) = {
  if reset {
    counter(heading).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
  }
  set heading(numbering: head-numbering, supplement: supplement)
  // context is required here because config-store is a state.
  show heading: it => context {
    core-heading(config-store.get(), it.level, _fmt-appendix-heading(it))
  }
  set math.equation(numbering: _make-eq-numbering(eq-numbering, eq-chapterwise))
  content
}
