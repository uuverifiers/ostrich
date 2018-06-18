(declare-fun a () String)
(declare-fun b () String)
(declare-fun z () String)

(assert (= (str.++ "test" a) "testhello"))

(check-sat)
