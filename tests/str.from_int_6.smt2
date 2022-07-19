
(declare-const w String)
(declare-const x Int)
(declare-const y Int)

(assert (= (str.substr w 0 3) (str.from_int x)))
(assert (= (str.substr w 10 3) (str.from_int y)))

(assert (> x (* 2 y)))
(assert (>= y 0))

(check-sat)
