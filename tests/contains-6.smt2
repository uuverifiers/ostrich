(set-logic QF_S)

(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const res String)

(assert(= res (str.replace_all x y z)))
(assert (not (str.contains x y)))

(check-sat)
