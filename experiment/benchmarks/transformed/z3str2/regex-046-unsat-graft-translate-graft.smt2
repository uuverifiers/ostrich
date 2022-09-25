(declare-const x String)
(assert (str.in.re x (str.to.re "`")))
(assert (> 1 (str.len x)))
(check-sat)
