(set-logic QF_S)

(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const res String)

(assert(= res (str.replace_all x y z)))
(assert (str.in_re x (re.*(str.to_re "ab"))))
(assert (not(str.in_re y (re.*(str.to_re "ab")))))
(assert(not (= res "")))

(check-sat)
