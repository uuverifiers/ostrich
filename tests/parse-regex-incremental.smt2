

(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "^[a-zA-Z][a-zA-Z0-9-_\.]{1,20}$")))

(check-sat)
(get-model)

(assert (str.in.re w (re.* (re.range "a" "z"))))

(check-sat)
(get-model)

(assert (= (str.len w) 5))

(check-sat)
(get-model)
