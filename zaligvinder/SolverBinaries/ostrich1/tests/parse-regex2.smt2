(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "[\+]\d{2}[\(]\d{2}[\)]\d{4}[\-]\d{4}")))

(check-sat)
(get-model)
