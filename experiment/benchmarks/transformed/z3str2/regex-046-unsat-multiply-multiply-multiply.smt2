(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "aaaaaaaa"))))
(assert (> 8 (str.len x)))
(check-sat)
