(set-logic QF_SLIA)
(set-info :status unsat)

(declare-fun x () String)
(declare-fun y () String)

(assert (str.in_re x (re.* (str.to_re "a"))))
(assert (str.in_re y (re.* (str.to_re "a"))))
(assert (not (str.prefixof y (str.++ y x))))

(check-sat)
