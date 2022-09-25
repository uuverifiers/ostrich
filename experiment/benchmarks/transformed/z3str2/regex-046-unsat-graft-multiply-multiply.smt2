(declare-const x String)
(assert (str.in.re x (str.to.re "aaaa")))
(assert (> (str.len x) 4))
(check-sat)
