

(declare-const w String)

(assert (str.in_re w (re.case_insensitive (re.from_ecma2020 '[a-c]+'))))
(assert (str.in_re w (re.case_insensitive (re.from_ecma2020 '[d-f]+'))))

(check-sat)
