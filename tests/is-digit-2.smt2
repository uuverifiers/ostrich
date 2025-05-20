            
(set-logic QF_S)

(declare-fun x () String)

(assert (str.is_digit (str.at x 1)))
(assert (str.is_digit (str.at x 2)))

(check-sat)
(get-model)

