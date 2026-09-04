# Manus

Manus provides three independent Typst templates through one uniform export file:

- `daily-en` for English notes and reports;
- `am-zh` for Chinese academic articles;
- `cp-zh` for Chinese theses with cover and abstract pages.

## Use a template

```typst
#import "manus/manus.typ": daily-en, appendix

#show: daily-en.with(
  title: [A short note],
  authors: ((name: "Author", addition: "Affiliation"),),
  abstract: [What the note establishes.],
  keywords: ("example", "typst"),
)

= First section

Document body.

#appendix[
  = Supporting calculation

  Appendix body.
]
```

Paths are relative to the importing document. From the Manus root, import
`"manus.typ"`. Front-matter fields are optional; omitted or empty values produce no
blank fragments or PDF metadata. `cp-zh` reads `name`, `student-id`, and
`department` from the first author and accepts `anonymous: true` to mask them.

Named style data may override fonts, margin, headings, equations, figures, and a
content-valued header. Nested dictionaries merge with template defaults. Rendering
callbacks are not part of the style contract.

## Compose narrowly

A caller needing one template can avoid the facade:

```typst
#import "manus/daily-en.typ": daily-en
#show: daily-en.with(title: [A short note])
```

The facade only re-exports names; it performs no runtime template selection.
Templates normalize shared document data but own their presentation independently.
`appendix` is a stateless document part that composes with any template through
native heading, equation, and counter semantics.

Only a part with independent document meaning and more than one real use belongs
in `parts.typ`. Template-specific cover, title, and abstract helpers stay local.

## Platform boundary

The English default uses Microsoft YaHei as its CJK fallback. Chinese templates use
SimSun, SimHei, and KaiTi. Install these fonts or override the `fonts` dictionary.

## Contributing

Add an independent template file, then export its public name from `manus.typ`.
Put shared data normalization and pure formatting operations in `_common.typ`, not
template selection or body-wrapping style chains. Compile all fixtures in `tests/`
with Typst 0.15.1; generated PDF and image evidence is temporary and untracked.

## License

Manus is licensed under the MIT License. See `LICENSE`.
