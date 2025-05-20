            
(set-logic QF_S)

(declare-fun x () String)

(assert (str.is_digit x))

(check-sat)
(get-model)

