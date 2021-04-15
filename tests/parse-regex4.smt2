(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$")))

(check-sat)
(get-model)
