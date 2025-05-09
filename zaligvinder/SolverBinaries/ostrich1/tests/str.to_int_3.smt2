
(declare-const w String)

(assert (= 42 (str.to.int w)))
(assert (= (str.len w) 5))

(check-sat)
