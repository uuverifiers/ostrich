(declare-const x String)
(assert (str.in.re x (str.to.re "GG")))
(assert (> (str.len x) 2))
(check-sat)
