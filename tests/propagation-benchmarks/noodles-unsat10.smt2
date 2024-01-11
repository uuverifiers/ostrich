(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= (str.++ "2" y x) (str.++ x x "2")))
(assert (str.in_re x (re.++(str.to_re "2") (re.union (re.* (str.to_re "1"))(re.* (str.to_re "2"))))))
(assert (str.in_re y (re.++(str.to_re "2")(re.union (re.* (str.to_re "1"))(re.* (str.to_re "2"))))))

(check-sat)
(get-model)
