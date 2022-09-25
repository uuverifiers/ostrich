(declare-const x String)
(assert (str.in.re x (str.to.re "aa")))
(assert (> 2 (str.len x)))
(check-sat)
