(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "bb"))))
(assert (> 2 (str.len x)))
(check-sat)
