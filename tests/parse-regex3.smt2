(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "^(?:0|\(?\+33\)?\s?|0033\s?)[1-79](?:[\.\-\s]?\d\d){4}$")))
(assert (str.prefixof "8" w))

(check-sat)
(get-model)
