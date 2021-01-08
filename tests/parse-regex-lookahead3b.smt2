(declare-const w String)

(assert (str.in.re w (re.from.str "(?=.*[\d\W])(?![.\n])(?=.*[A-Z])(?=.*[a-z]).{8,}$")))
(assert (str.in.re w (re.* (re.range "a" "z"))))

(check-sat)