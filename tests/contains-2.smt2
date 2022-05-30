(set-logic QF_S)

(declare-const x String)

(assert (not (= (str.contains x "A") true)))

(check-sat)
