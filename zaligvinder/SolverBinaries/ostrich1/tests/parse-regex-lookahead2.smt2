(declare-const w String)

(assert (str.in.re w (re.from.str "^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).*$")))

(check-sat)