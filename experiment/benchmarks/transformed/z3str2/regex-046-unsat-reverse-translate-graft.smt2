(declare-const x String)
(assert (str.in.re x (str.to.re "Y")))
(assert (> (str.len x) 1))
(check-sat)
