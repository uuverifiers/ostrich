(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= (str.++ z y x) (str.++ x x z)))
(assert (str.in_re x (re.++(str.to_re "2") re.all)))
(assert (str.in_re y (re.++(str.to_re "1") re.all)))
(assert (str.in_re z (re.++(str.to_re "2") re.all)))

(check-sat)
(get-model)
