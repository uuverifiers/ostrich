(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "aa"))))
(assert (> 0 (str.len x)))
(check-sat)
