(declare-const x String)
(assert (str.in.re x (re.* (str.to.re "g"))))
(assert (> 0 (str.len x)))
(check-sat)
