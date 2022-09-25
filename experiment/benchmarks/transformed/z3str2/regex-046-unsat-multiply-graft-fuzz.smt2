(declare-const x String)
(assert (str.in.re x (str.to.re "\\'\x0c'")))
(assert (> (str.len x) 4))
(check-sat)
