(set-logic QF_S)

(declare-const x String)

(assert (= (str.at x 2) "x"))
(assert (= (str.at x 3) "y"))
(assert (not (str.contains x "xy")))

(check-sat)
