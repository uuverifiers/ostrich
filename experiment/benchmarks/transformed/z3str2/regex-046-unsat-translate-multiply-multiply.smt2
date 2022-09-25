(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "BBBB"))))
(assert (> 4 (str.len x)))
(check-sat)
