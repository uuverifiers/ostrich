(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "PP"))))
(assert (> 2 (str.len x)))
(check-sat)
