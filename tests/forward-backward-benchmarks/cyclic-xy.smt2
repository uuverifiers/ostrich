(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)

(assert (= (str.++ y x) (str.++ x y)))
(assert (str.in_re x (re.union (str.to_re "a") (str.to_re "b"))))
(assert (str.in_re y (re.union (str.to_re "bab") (str.to_re "aba"))))

(check-sat)
(get-model)
