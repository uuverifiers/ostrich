(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun f (String) Int)

(assert (= (f a) 1))
(assert (= (f b) 2))
(assert (= a "abc"))
(assert (= b (str.++ "a" c)))
(assert (= c "bc"))

(check-sat)
