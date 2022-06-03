(set-logic QF_S)

(declare-const x String)
(declare-const y String)

(assert (not (= (str.prefixof x y) true)))

(check-sat)
