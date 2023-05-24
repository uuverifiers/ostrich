(set-info :status sat)
(declare-fun a () String)
(declare-fun b () String)

(declare-fun i () Int)
(declare-fun j () Int)

(assert (str.in_re a (re.union (str.to_re "hhhbbb") (str.to_re "bhhh"))))
(assert (= (str.indexof a "" j) i))
(assert (= i j))

(check-sat)
(get-model)