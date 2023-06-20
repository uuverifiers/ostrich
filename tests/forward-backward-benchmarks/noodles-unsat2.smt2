(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= (str.++ z y x) (str.++ x z x z)))
(assert (str.in_re x (re.* (str.to_re "1"))))
(assert (str.in_re y (re.++ (re.+ (str.to_re "1"))  (re.+ (str.to_re "2")) )))
(assert (str.in_re z (re.* (str.to_re "2"))))

(check-sat)
(get-model)
