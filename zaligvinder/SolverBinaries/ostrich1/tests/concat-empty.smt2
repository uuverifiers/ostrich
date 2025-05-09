(declare-fun a () String)
(assert (not (= a (str.++ a ""))))
(check-sat)
