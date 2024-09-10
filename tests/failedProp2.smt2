(set-logic QF_SLIA)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () Int)

(assert (not (= (str.suffixof x (str.at x 1)) (= x ""))))
(check-sat)
(exit)
