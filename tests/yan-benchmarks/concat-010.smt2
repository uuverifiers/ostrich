(declare-fun a () String)
(declare-fun b () String)
(declare-fun z () String)

(assert (= (str.++ "test" (str.++ a "num") ) "testhellonum"))

(check-sat)
