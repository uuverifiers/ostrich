(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= (str.++ z y x) (str.++ x x z)))
(assert (str.in_re x (re.+ (str.to_re "1111"))))
(assert (str.in_re y (str.to_re "11")))
(assert (str.in_re z (re.+ (str.to_re "111"))))

(check-sat)
(get-model)
