(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= (str.++ a b b a) (str.++ c d d c)))
(assert (>= (str.len a) 1))

(check-sat)
(get-model)
