(set-info :status sat)
(declare-fun a () String)
(declare-fun b () String)

(declare-fun i () Int)
(declare-fun j () Int)


(assert (= "hhhhjjj" (str.++ "h" a)))
(assert (= (str.indexof a "hhh" j) i))
(assert (>= i 0))
(assert (= j 0))
(check-sat)
(get-model)