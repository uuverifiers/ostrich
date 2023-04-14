(set-info :status unsat)
(declare-fun a () String)
(declare-fun b () String)

(declare-fun i () Int)

(assert (= "hhhhjjj" (str.++ "h" a)))
(assert (= (str.indexof a "hhh" 0) i))
(assert (not (= i 0)))

(check-sat)
(get-model)