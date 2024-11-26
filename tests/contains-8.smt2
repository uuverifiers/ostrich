(set-logic QF_S)

(declare-const x String)
(declare-const y String)
(declare-const z String)
(declare-const res String)

(assert(= res (str.replace_re_all x (re.comp (re.*(str.to_re "ab"))) z)))
(assert (str.in_re x (re.*(str.to_re "ab"))))
(assert(not (= res "")))
(check-sat)
(get-model)
