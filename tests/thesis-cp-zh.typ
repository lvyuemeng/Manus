#import "../manus.typ": cp-zh, appendix

#show: cp-zh.with(
  title: (zh: [中文学位论文模板检验], en: [Chinese Thesis Template Fixture]),
  authors: ((
    name: "示例作者",
    student-id: "2026000001",
    department: "数学与统计学院",
  ),),
  abstract: [用于验证封面、摘要和正文样式的最小文档。],
  keywords: ("排版", "检验"),
  anonymous: sys.inputs.at("anonymous", default: "false") == "true",
)

= 一级标题

正文首行用于观察标题后的间距，并引用文献 @fixture2026。

== 二级标题

本段验证标题层级和编号公式。

=== 三级标题

$
  norm(u+v)^2 = (u+v) dot (u+v).
$

#figure(
  table(
    columns: 2,
    table.header([对象], [性质]),
    [$u$], [向量],
  ),
  caption: [代表性表格。],
)

#appendix(supplement: [附录])[
  = 检验附录

  附录正文必须采用独立编号。

  $
    sin(0) = 0.
  $
]

#bibliography("references.bib")
