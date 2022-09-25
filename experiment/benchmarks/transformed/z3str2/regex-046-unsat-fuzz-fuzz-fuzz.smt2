(declare-const x String)
(assert (str.in.re x (re.* (str.to.re "a"))))
(assert (> 0 (str.to.int x)))
(check-sat)
