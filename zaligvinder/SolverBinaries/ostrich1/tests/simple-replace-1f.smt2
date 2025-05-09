(set-logic QF_S)

(declare-fun x_7 () String)
(declare-fun x_10 () String)

(assert (= x_7 (str.replace "HelloWorld" "e" "a")))
(assert (= x_7 "HolloWorld"))

(check-sat)
(get-model)
