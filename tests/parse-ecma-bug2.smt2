
(declare-const w String)
(assert (str.in.re w (re.from_ecma2020 '^[-a]')))

(assert (= w ""))

(check-sat)
