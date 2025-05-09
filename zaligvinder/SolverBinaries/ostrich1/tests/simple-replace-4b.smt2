(set-logic QF_S)
(set-option :strings-exp true)
(set-option :produce-models true)

(declare-fun x_7 () String)
(declare-fun x_10 () String)
(declare-fun x_11 () String)
(declare-fun x_12 () String)
(declare-fun x_13 () String)


(assert (= x_10 (str.++ x_11 x_12 )))
(assert (= x_7 (str.replace x_10 "e" "a")))
(assert (= x_7 "hello"))

(check-sat)
(get-model)
