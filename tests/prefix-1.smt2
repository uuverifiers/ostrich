(set-logic QF_S)

(declare-const x String)

(assert (not (= (str.prefixof x x) true)))

(check-sat)
