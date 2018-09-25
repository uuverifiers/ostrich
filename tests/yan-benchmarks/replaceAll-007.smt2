(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const w String)
(declare-const v String)

(assert (= x (str.replaceallre y (str.to.re "0") z)))
(assert (= z (str.replaceallre w (str.to.re "1") v)))

(assert (str.in.re x (re.++ (str.to.re "*") (re.* (str.to.re "*")))))
(assert (str.in.re y (re.* (str.to.re "0"))))
(assert (str.in.re z (re.* (str.to.re "*"))))
(assert (str.in.re w (re.* (str.to.re "1"))))
(assert (str.in.re v (str.to.re "**")))

(check-sat)
