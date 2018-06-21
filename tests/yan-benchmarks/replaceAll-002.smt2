(declare-const x String)
(declare-const y String)
(declare-const z String)

(assert (= x (str.replaceall-re y (str.to.re "0") z)))

(assert (str.in.re x (re.++ (str.to.re "\*") (re.* (str.to.re "\*")))))
(assert (str.in.re y (re.* (str.to.re "0"))))
(assert (str.in.re z (re.* (str.to.re "\*"))))

(check-sat)
