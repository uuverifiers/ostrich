(set-logic QF_S)

(declare-const w String)

; currently not working; the : is unexpected
(assert (str.in.re w (re.from.str "^(?:0|\(?\+33\)?\s?|0033\s?)[1-79](?:[\.\-\s]?\d\d){4}$")))

(check-sat)
(get-model)
