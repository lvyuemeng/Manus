#import "../manus.typ": daily-en, appendix

#show: daily-en.with(
  title: [Daily template fixture],
  authors: ((name: "Ada Example", addition: "Layout Laboratory"),),
  abstract: [A compact fixture for the public English template.],
  keywords: ("layout", "fixture"),
)

= First-level heading

The first body line exposes the lower heading gap. The fixture cites @fixture2026.

== A deliberately long second-level heading that wraps onto another line

The wrapped heading must remain attached to this paragraph.

=== Third-level heading

The equation below exercises numbered display spacing.

$
  integral_0^1 x dif x = 1/2.
$

#figure(
  table(
    columns: 2,
    table.header([Input], [Output]),
    [$x$], [$x^2$],
  ),
  caption: [Representative table figure.],
)

#pagebreak()
#v(18cm)

== Heading near a page boundary

Sticky layout must keep this heading with its first body line.

#appendix[
  = Fixture appendix

  Appendix equation numbering must remain valid.

  $
    (a+b)^2 = a^2 + 2 a b + b^2.
  $
]

#bibliography("references.bib")
