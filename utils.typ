// ==================================================
// utils.typ — pure utility functions (no external deps)
// ==================================================

// --------------------------------------------------
// mask-field — replace personal data with a block bar
// when compiling an anonymous copy.
// FIX: "█" * n is not valid Typst; use array fill + join.
// --------------------------------------------------
#let mask-field(value, anonymous, length: 5) = {
  if anonymous { range(length).map(_ => "█").join() } else { value }
}

// --------------------------------------------------
// fill-lines — normalise a title (str or array) to at
// least `min-lines` entries, padding with a full-width space.
// --------------------------------------------------
#let fill-lines(title, min-lines: 2) = {
  let lines = if type(title) == str { title.split("\n") } else { title }
  if lines.len() < min-lines {
    lines + range(min-lines - lines.len()).map(_ => "　")
  } else {
    lines
  }
}

// --------------------------------------------------
// double-underline — two rules directly beneath content,
// sized to match the content's measured width.
// --------------------------------------------------
#let double-underline(body, stroke: 0.5pt + black, gap: 2pt) = context {
  let w = measure(body).width
  stack(spacing: gap,
        body,
        line(length: w, stroke: stroke),
        line(length: w, stroke: stroke))
}

// --------------------------------------------------
// hidden-heading — invisible bookmark / PDF-outline anchor.
// `numbering: none` is placed AFTER ..args so the caller
// cannot accidentally re-enable numbering.
// --------------------------------------------------
#let hidden-heading(..args) = {
  place(hide(heading(..args, numbering: none)))
}

// --------------------------------------------------
// distribute-chars — lay out a string's clusters with
// equal 1fr gaps (useful for justified CJK label text).
//
// body     must be a str.
// text-args are forwarded as NAMED args to text(), so
//           font/size/weight etc. can be passed freely.
// --------------------------------------------------
#let distribute-chars(body, width: auto, tail: none, ..text-args) = {
  assert(type(body) == str,
    message: "distribute-chars: `body` must be a string, got " + type(body))
  let chars = body.clusters().map(c => text(..text-args.named(), c))
  let inner = block(width: width, stack(dir: ltr, spacing: 1fr, ..chars))
  if tail != none { stack(dir: ltr, inner, tail) } else { inner }
}

// --------------------------------------------------
// full-underline — render each positional argument as a
// full-width block with a bottom border.
// --------------------------------------------------
#let full-underline(stroke: 0.5pt, ..lines) = {
  lines.pos().map(ln =>
    block(
      width: 100%,
      stroke: (bottom: stroke),
      inset:  (bottom: 4pt),
      outset: (bottom: 2pt),
      ln,
    )
  ).join()
}

// --------------------------------------------------
// three-line-table — show-rule that converts a plain
// table into booktabs / three-line style.
// Bails out if ANY hline or vline is already present,
// so user-customised tables are never touched.
// --------------------------------------------------
#let three-line-table(it) = {
  let has-rule = it.children.any(c =>
    c.func() == table.hline or c.func() == table.vline)
  if has-rule { return it }

  let col-count = if type(it.columns) == int { it.columns }
                  else { it.columns.len() }
  let header    = it.children.find(c => c.func() == table.header)
  let cells     = it.children.filter(c => c.func() == table.cell)

  // When there is no explicit header, promote the first row.
  let (hdr, body-cells) = if header != none {
    (header, cells)            // cells here are already body-only
  } else {
    (table.header(..cells.slice(0, col-count)), cells.slice(col-count))
  }

  table(
    columns: it.columns,
    stroke:  none,
    table.hline(stroke: 1.5pt),
    hdr,
    table.hline(stroke: 0.75pt),
    ..body-cells,
    table.hline(stroke: 1.5pt),
  )
}

// --------------------------------------------------
// field-theme — factory for grid-based info layouts
// (cover pages, data sheets, etc.).
//
// Shorthand API (most common):
//   field-theme(
//     font-label: ("Times New Roman", "SimSun"),
//     size-label: 14pt, weight-label: "bold",
//     font-value: ("Times New Roman", "KaiTi"),
//     size-value: 14pt,
//   )
//
// Full control (pass any function content => content):
//   field-theme(
//     decorate-label: content => rect(stroke: none, content),
//     decorate-value: content => rect(stroke: (bottom: 1pt), content),
//   )
//
// Returns: (label, value, row, rows)
//   label / value  — the decorator functions themselves
//   row(key, val, col-label:, col-val:)   — single grid row
//   rows(key, val, min-lines:, col-label:, col-val:) — multi-line row
// --------------------------------------------------

// Build a rect-based decorator from simple text-style params.
// Produces content => rect(..., text(..props, content)).
#let _make-decorator(stroke: none, font: none, size: none, weight: "regular") = {
  let props = (:)
  if font  != none        { props.insert("font",   font)   }
  if size  != none        { props.insert("size",   size)   }
  if weight != "regular"  { props.insert("weight", weight) }

  if props == (:) {
    content => rect(width: 100%, stroke: stroke, content)
  } else {
    content => rect(width: 100%, stroke: stroke, text(..props, content))
  }
}

#let field-theme(
  font-label:     none,
  size-label:     none,
  weight-label:   "regular",
  font-value:     none,
  size-value:     none,
  weight-value:   "regular",
  decorate-label: none,
  decorate-value: none,
) = {
  let dl = if decorate-label != none { decorate-label }
           else { _make-decorator(stroke: none,
                                  font:   font-label,
                                  size:   size-label,
                                  weight: weight-label) }
  let dv = if decorate-value != none { decorate-value }
           else { _make-decorator(stroke: (bottom: 0.5pt + black),
                                  font:   font-value,
                                  size:   size-value,
                                  weight: weight-value) }

  let row(key, val, col-label: 1, col-val: 1) = (
    grid.cell(colspan: col-label, dl(key)),
    grid.cell(colspan: col-val,   dv(val)),
  )

  let rows(key, val, min-lines: 2, col-label: 1, col-val: 1) = {
    fill-lines(val, min-lines: min-lines)
      .enumerate()
      .map(((i, line)) => row(
        if i == 0 { key } else { "" },
        line,
        col-label: col-label,
        col-val:   col-val,
      ))
      .flatten()
  }

  (label: dl, value: dv, row: row, rows: rows)
}
