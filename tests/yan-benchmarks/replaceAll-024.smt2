(declare-const x String)
(declare-const y String)
(declare-const z String)
(assert (= x (str.replaceallre y (re.++ (re.++ (re.* (str.to.re "1")) (re.* (str.to.re "0"))) (str.to.re "10")) z)))

(assert (str.in.re x (re.++ (re.* (str.to.re "01")) (str.to.re "01"))))

(check-sat)
