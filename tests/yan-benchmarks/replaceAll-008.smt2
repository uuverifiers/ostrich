(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const w String)
(declare-const v String)

(assert (= x (str.replaceall-re y (str.to.re "*") z)))
(assert (= z (str.replaceall-re w (str.to.re "*") v)))

(assert (str.in.re y (str.to.re "******")))
(assert (str.in.re z (str.to.re "\\")))
(assert (str.in.re w (str.to.re "**")))
(assert (str.in.re v (str.to.re "\\")))

(check-sat)
