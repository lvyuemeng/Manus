#import "../parts.typ": appendix

#set heading(numbering: "1.1")
#set math.equation(numbering: "(1.1)")

= Before appendix <before>

$ 1 + 1 = 2 $

#appendix[
  = First appendix <first-appendix>

  Refer to @first-appendix.

  $ 2 + 2 = 4 $
]

#appendix(supplement: [附录])[
  = 第二个附录 <second-appendix>

  参见 @second-appendix。

  $ 3 + 3 = 6 $
]

= After appendices <after>

$ 4 + 4 = 8 $
