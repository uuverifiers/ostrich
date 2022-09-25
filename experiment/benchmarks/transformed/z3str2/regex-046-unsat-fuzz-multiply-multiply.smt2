(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "aaaa"))))
(assert (> 4 (str.len x)))
(check-sat)
