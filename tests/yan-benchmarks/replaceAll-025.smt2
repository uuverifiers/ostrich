(declare-const x String)
(declare-const y String)
(declare-const z String)
(assert (= x (str.replaceallre y (re.++ (str.to.re "a") (re.* (str.to.re "a"))) z)))

(assert (str.in.re x (str.to.re "cccc")) )
(assert (str.in.re y (re.++ (str.to.re "aa") (str.to.re "ccc"))))
(assert (str.in.re z (re.* (str.to.re "c"))))

(check-sat)
