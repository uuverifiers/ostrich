(declare-const x String)
(assert (str.in.re x (str.to.re "j")))
(assert (> 1 (str.len x)))
(check-sat)
