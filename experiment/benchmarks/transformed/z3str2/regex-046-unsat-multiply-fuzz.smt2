(declare-const x String)
(assert (str.in.re x (re.* (str.to.re "aa"))))
(assert (> 4 (str.to.int x)))
(check-sat)
