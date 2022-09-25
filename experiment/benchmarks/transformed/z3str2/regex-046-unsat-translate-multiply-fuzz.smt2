(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "2B"))))
(assert (> 3 (str.to.int x)))
(check-sat)
