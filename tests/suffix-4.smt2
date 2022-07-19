(set-logic QF_S)

(declare-const x String)
(declare-const y String)

(assert (not (= (str.suffixof x y) true)))

(check-sat)
