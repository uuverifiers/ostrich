(declare-const x String)
(assert (str.in.re x (str.to.re "'\n'")))
(assert (> (str.len x) 1))
(check-sat)
