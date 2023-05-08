(set-info :status sat)
(declare-fun a () String)
(declare-fun b () String)

(declare-fun i () Int)
(declare-fun j () Int)

(assert (str.in_re a (re.union (str.to_re "hhhbbb") (str.to_re "bhhh"))))
(assert (str.in_re b (re.union (str.to_re "hh") (str.to_re "bb"))))
(assert (= (str.substr a i j) ""))
(assert (> i 3))
(assert (> j 0))

(check-sat)
(get-model)