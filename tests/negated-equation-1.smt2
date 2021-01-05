(declare-fun a () String)
(assert (not (= (str.at a 0) (str.at "" 0))))
(assert (= (str.len a) 0))
(check-sat)
