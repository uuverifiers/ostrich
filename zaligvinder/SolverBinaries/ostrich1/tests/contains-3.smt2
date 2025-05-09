(set-logic QF_S)

(declare-const x String)

(assert (not (= (str.contains x x) true)))

(check-sat)
