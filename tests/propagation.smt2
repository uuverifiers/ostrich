
(declare-fun f (String) Int)

(declare-const x String)
(declare-const y String)

(assert (= (f x) 1))
(assert (= (f y) 2))

(assert (= x "aaaaa"))
(assert (str.in_re y (re.from_ecma2020 'a{5,}')))

(check-sat)
(get-model)
