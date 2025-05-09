(set-info :status unsat)
(declare-fun a () String)
(declare-fun b () String)

(declare-fun i () Int)
(declare-fun j () Int)

(assert (str.in_re a (re.union (str.to_re "hhhbbb") (str.to_re "bhhh"))))
(assert (= (str.indexof a "hhh" j) i))

(assert (= i 2))
(assert (> j 0))

(check-sat)
(get-model)