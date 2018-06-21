(set-option :auto-config true)
(set-option :produce-models true)

(declare-fun a () String)
(declare-fun b () String)

(assert (= (str.++ a b) "testhello"))
(assert (= a "hello"))

(check-sat)
