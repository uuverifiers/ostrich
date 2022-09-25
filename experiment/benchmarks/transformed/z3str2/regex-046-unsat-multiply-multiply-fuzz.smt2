(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "a"))))
(assert (> 5 (str.to.int x)))
(check-sat)
