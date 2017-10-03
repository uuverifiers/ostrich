(set-logic QF_S)

(declare-fun x_7 () String)
(declare-fun x_10 () String)

(assert (= x_7 (str.replaceall "HelloWorld" "e" "a")))

(check-sat)
(get-model)
