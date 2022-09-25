(declare-const x String)
(assert (str.in.re x (re.* (str.to.re "b"))))
(assert (> 1 (str.len x)))
(check-sat)
