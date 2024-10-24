(set-logic QF_S)

(declare-const x String)
(declare-const y String)
(declare-const z String)

(assert (str.contains y z))
(assert (= x (str.++ y y)))
(assert (not (str.contains x z)))

(check-sat)
