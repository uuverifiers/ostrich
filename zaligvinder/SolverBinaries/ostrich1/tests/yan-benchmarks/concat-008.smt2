(declare-fun a () String)
(declare-fun b () String)
(declare-fun z () String)

(assert (= (str.++ (str.++ "test" a) "num") "testhellonum"))

(check-sat)
