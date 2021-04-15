

(declare-const w String)

(assert (str.in_re w (re.case_insensitive (re.from_ecma2020 '[a-z]+'))))
(assert (str.in_re w (re.case_insensitive (re.from_ecma2020 '.{5,10}'))))
(assert (str.contains w "ABC"))

(check-sat)
