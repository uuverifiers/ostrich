(declare-const x String)
(assert (str.in.re x (re.* (str.to.re "80e"))))
(assert (> 3 (str.len x)))
(check-sat)
