(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "hh"))))
(assert (> 2 (str.len x)))
(check-sat)
