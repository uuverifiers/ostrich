(declare-const x String)
(declare-const y String)
(declare-const z String)

(assert (= x (str.replaceallre y (str.to.re "0101") z)))

(assert (str.in.re x (re.++ (re.* (str.to.re "0")) (str.to.re "11"))))
(assert (str.in.re y (re.* (str.to.re "01"))))
(assert (str.in.re z (re.* (str.to.re "10"))))

(check-sat)
