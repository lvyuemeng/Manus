// ==================================================
// main.typ — template registry and public entry point
// ==================================================

#import "templates/daily-en.typ":     tmpl as _daily-en
#import "templates/thesis-am-zh.typ": tmpl as _am-zh
#import "templates/thesis-cp-zh.typ": tmpl as _cp-zh
#import "core.typ": appendix

// Re-export appendix so callers only need to import main.typ.
#let appendix = appendix

// --------------------------------------------------
// Template registry — add new templates here.
// --------------------------------------------------
#let _registry = (
  "daily-en": _daily-en,
  "am-zh":    _am-zh,
  "cp-zh":    _cp-zh,
)

#let _select(name) = {
  if name in _registry { _registry.at(name) }
  else {
    panic("Unknown template '" + name + "'. "
        + "Available: " + _registry.keys().join(", "))
  }
}

// --------------------------------------------------
// mine — public entry point
//
// Usage (show-rule form):
//   #show: mine.with(
//     template:  "cp-zh",
//     title:     (zh: "论文标题", en: "Thesis Title"),
//     authors:   ((
//       name:       "张三",
//       student-id: "2024000001",
//       department: "数学与统计学院",
//     ),),
//     abstract:  [摘要内容……],
//     keywords:  ("关键词一", "关键词二"),
//   )
// --------------------------------------------------
#let mine(
  template: "daily-en",
  title:    none,
  authors:  (),
  abstract: none,
  keywords: none,
  body,
  ..extra,
) = {
  // assert(title != none,
  //   message: "mine(): `title` is required")
  // assert(type(authors) == array and authors.len() > 0,
  //   message: "mine(): `authors` must be a non-empty array of dictionaries")

  _select(template)((
    title:    title,
    authors:  authors,
    abstract: abstract,
    keywords: keywords,
    body:     body,
    ..extra.named(),
  ))
}
