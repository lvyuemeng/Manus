#import "templates/daily-en.typ": tmpl as daily-en
#import "templates/thesis-am-zh.typ": tmpl as am-zh
#import "templates/thesis-cp-zh.typ": tmpl as cp-zh
#import "core.typ": appendix

#let select-template = name => {
  if name == "daily-en" { daily-en } else if name == "am-zh" { am-zh } else if name == "cp-zh" { cp-zh } else {
    panic("Unknown template: " + name)
  }
}

#let mine(
  template: "daily-en",
  title: none,
  authors: (),
  abstract: none,
  keywords: none,
  body,
  ..extra,
) = {
  let tmpl = select-template(template)

  // apply in dictionary
  tmpl((
    title: title,
    authors: authors,
    abstract: abstract,
    keywords: keywords,
    body: body,
    ..extra.named(),
  ))
}

