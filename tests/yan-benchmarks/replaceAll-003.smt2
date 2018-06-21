(declare-const x String)
(declare-const y String)
(declare-const z String)

(assert (= x (str.replaceall-re y (str.to.re "*") z)))

(assert (str.in.re y (str.to.re "******")))
(assert (str.in.re z (str.to.re "\\")))

(check-sat)
