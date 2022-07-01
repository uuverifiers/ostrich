
(declare-const w String)

(assert (= (str.to_int (str.substr w 0 10)) 123))
(assert (= (str.to_int (str.substr w 10 10)) 321))

(check-sat)
