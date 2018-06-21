(set-option :auto-config true)
(set-option :produce-models true)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun z () String)

(assert (= (str.++ a "testhello") "hello"))

(check-sat)
