(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= (str.++ "1111" z "1" y x "21111") (str.++ "11" x x "111" z)))
(assert (str.in_re x (re.++ (re.+ (str.to_re "1"))  (re.+ (str.to_re "2")) )))
(assert (str.in_re y (re.++ (re.+ (str.to_re "1"))  (re.* (str.to_re "2")) )))
(assert (str.in_re z (re.++ (re.+ (str.to_re "2"))  (re.* (str.to_re "1")) )))

(check-sat)
(get-model)
