(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "YY"))))
(assert (> 2 (str.len x)))
(check-sat)
