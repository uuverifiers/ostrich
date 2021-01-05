(declare-fun x () String)
(assert (distinct (str.at (str.++ "A" x) 1) (str.at x 0)))
(check-sat)
