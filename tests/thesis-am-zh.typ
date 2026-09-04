#import "../manus.typ": am-zh, appendix

#show: am-zh.with(
  title: [中文期刊模板检验],
  authors: ((name: "示例作者", addition: "排版研究室"),),
  abstract: [用于验证公开中文期刊模板的最小文档。],
  keywords: ("排版", "检验"),
)

= 一级标题

正文首行用于观察标题后的间距，并引用文献 @fixture2026。

== 二级标题

本段验证正文、标题和编号公式的共同布局。

=== 三级标题

$
  sum_(k=1)^n k = frac(n(n+1), 2).
$

#figure(
  table(
    columns: 2,
    table.header([输入], [输出]),
    [$n$], [$n(n+1)/2$],
  ),
  caption: [代表性表格。],
)

#appendix(supplement: [附录])[
  = 检验附录

  附录正文必须采用独立编号。

  $
    exp(0) = 1.
  $
]

#bibliography("references.bib")
