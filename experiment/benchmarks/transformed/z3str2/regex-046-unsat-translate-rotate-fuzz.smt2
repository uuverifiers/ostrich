(declare-const x String)
(assert (str.in.re x (re.+ (str.to.re "7"))))
(assert (> 1 (str.to.int x)))
(check-sat)
