(set-logic QF_SLIA)

(declare-const x String)
(declare-const y String)

(assert (= y (str.replace x "l" "L")))
(assert (= (str.len x) 10))

(assert (str.contains x "l"))

(check-sat)
