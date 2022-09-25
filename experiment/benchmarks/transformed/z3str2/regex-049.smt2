(set-logic QF_S)
(set-info :status sat)

(declare-const key String)
(declare-const val String)

(assert (str.in.re key (re.* (re.range "a" "b"))) )
(assert (<= 5 (str.len key)))
(assert (>= 7 (str.len key)))




(check-sat)
(get-model)
