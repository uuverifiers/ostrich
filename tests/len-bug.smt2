
(declare-const x String)
(declare-const y String)
(declare-const a Int)
(declare-const b Int)

(assert (= x "abc"))
(assert (= (str.len x) (+ (str.len y) 1)))
(assert (= a (str.len x)))
(assert (= b (str.len y)))

(assert (= a 1)) ; should be unsat, previously gave sat

(check-sat)
