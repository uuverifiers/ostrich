
(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (= x (str.++ "x" z)))
(assert (= y (str.substr x 3 (- (str.len x) 5))))
(assert (str.in_re y (re.from_ecma2020 'a+b+')))
(assert (= (str.at x 4) "c"))

(check-sat)