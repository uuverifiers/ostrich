(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const w String)
(declare-const v String)

(assert (= x (str.replaceallre y (str.to.re "0101") z)))
(assert (= y (str.replaceallre w (str.to.re "a") v)))

(assert (str.in.re x (re.++ (re.* (str.to.re "0")) (str.to.re "11"))))
(assert (str.in.re y (re.* (str.to.re "01"))))
(assert (str.in.re z (re.* (str.to.re "10"))))
(assert (str.in.re v (re.* (str.to.re "10"))))

(check-sat)
