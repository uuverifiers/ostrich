(set-logic QF_S)

(declare-const x String)

(assert (= (str.at x (- (str.len x) 1)) "x"))
(assert (= (str.at x (- (str.len x) 2)) "y"))
(assert (< (str.len x) 2))

(check-sat)
