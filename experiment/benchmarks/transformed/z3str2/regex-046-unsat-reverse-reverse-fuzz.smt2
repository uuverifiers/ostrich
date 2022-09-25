(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "'\x0c'"))))
(assert (> 1 (str.len x)))
(check-sat)
