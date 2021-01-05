(declare-fun a () String)
(assert (= (str.len (str.substr a 0 (- 1))) 0))
(check-sat)
