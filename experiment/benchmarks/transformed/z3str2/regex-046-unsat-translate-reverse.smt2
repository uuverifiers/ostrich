(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "P"))))
(assert (> 1 (str.len x)))
(check-sat)
