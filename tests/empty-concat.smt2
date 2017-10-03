(set-logic QF_S)

(declare-fun sigmaStar_0 () String)
(declare-fun literal_1 () String)
(declare-fun x_2 () String)
(declare-fun literal_3 () String)
(declare-fun x_4 () String)

(assert (= x_2 (str.++ literal_1 sigmaStar_0)))
(check-sat)
(get-model)
