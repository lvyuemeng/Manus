#import "_common.typ": make-eq-numbering

#let appendix(
  supplement: [Appendix],
  head-numbering: "A.1",
  eq-numbering: "(A.1)",
  eq-chapterwise: true,
  reset: true,
  body,
) = {
  if reset {
    counter(heading).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
  }
  set heading(numbering: head-numbering, supplement: supplement)
  set math.equation(numbering: make-eq-numbering(eq-numbering, eq-chapterwise))
  body
}
