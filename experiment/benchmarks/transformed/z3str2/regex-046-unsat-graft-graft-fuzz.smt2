(declare-const x String)
(assert (str.in.re x (str.to.re "a")))
(assert (> 2 (str.to.int x)))
(check-sat)
