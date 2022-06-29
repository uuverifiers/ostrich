
(declare-const w String)
(declare-const x Int)
(declare-const y Int)

(assert (= (str.to_int (str.substr w 0 10)) x))
(assert (= (str.to_int (str.substr w 10 10)) y))

(assert (> x (* 2 y)))
(assert (>= y 1000))

(check-sat)
