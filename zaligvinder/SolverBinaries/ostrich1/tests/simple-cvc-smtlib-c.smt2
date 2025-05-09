
(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun a_len () Int)

(assert (= b (str.++ a "c")))
; (assert (= (str.len a) (str.len b)))
(assert (str.in.re a (re.* (str.to.re "xy"))))
(assert (not (str.in.re b (re.* (str.to.re "xy")))))
(assert (= (str.len a) a_len))
(assert (> a_len 0))
(assert (= a_len 8))

(check-sat)