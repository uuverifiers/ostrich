(declare-fun a () String)
(declare-fun b () String)
(declare-fun z () String)

(assert (= (str.++ (str.++ a "hello") "num") "testhellonum"))

(check-sat)
