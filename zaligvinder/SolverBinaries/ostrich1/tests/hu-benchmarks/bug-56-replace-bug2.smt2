(set-logic QF_S)

(declare-fun x_4 () String)
(declare-fun sigmaStar_0 () String)

(assert (= x_4 (str.replace sigmaStar_0 "ab" "c")))

(assert (str.in_re x_4 (str.to_re "aa")))

(check-sat)
(get-model)
