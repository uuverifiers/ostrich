(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= (str.++ a "xy" b) (str.++ b "x" c)))
(assert (<= (str.len a) 3))

(check-sat)
(get-model)
