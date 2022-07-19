(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= (str.++ a b) (str.++ b a)))
(assert (>= (str.len a) 1))
(assert (>= (str.len b) 5))

(check-sat)
(get-model)
