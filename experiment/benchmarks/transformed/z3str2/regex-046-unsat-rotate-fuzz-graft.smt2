(declare-const x String)
(assert (str.in.re x (str.to.re "a")))
(assert (> (str.to.int x) 2))
(check-sat)
