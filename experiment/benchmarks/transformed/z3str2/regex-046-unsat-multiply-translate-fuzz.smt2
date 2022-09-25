(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "+mG"))))
(assert (> 1 (str.to.int x)))
(check-sat)
