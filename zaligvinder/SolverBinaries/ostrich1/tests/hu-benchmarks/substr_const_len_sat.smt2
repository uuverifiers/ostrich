(set-info :status sat)
(declare-fun a () String)
(declare-fun b () String)

(declare-fun i () Int)
(declare-fun j () Int)

(assert (str.in_re a (re.union (str.to_re "hhhbbb") (str.to_re "bhhh"))))
(assert (str.in_re b (re.union (str.to_re "hh") (str.to_re "bb"))))
(assert (= (str.substr a i j) b))
(assert (= i 0))
(assert (= j 2))

(check-sat)
(get-model)