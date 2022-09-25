(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "a"))))
(assert (> 4 (str.len x)))
(check-sat)
