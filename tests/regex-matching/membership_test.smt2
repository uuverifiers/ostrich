(set-logic QF_S)

(declare-fun s () String)

; Use ECMAScript regex parser
(assert (str.in.re s (re.from_ecma2020 "[a-z]+")))

; Concrete value to test membership
(assert (= s "hello"))

(check-sat)
(get-model)