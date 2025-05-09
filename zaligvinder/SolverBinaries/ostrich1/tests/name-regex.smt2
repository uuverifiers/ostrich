(set-logic QF_S)

(declare-const w String)

(assert (str.in.re w (re.from.str "^[a-z\d\.]{5,}$")))

; inconsistent
(assert (str.contains w "]"))

(check-sat)
