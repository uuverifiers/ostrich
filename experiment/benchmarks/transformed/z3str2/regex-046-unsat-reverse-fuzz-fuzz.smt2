(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "s"))))
(assert (> 0 (str.len x)))
(check-sat)
