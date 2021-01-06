(set-logic QF_S)

(declare-const x String)
(declare-const g1 String)
(declare-const g2 String)

(assert (= g1 ((_ str.extract 1) x (re.from.ecma2020 'abc([a-z]+)([A-Z]+)'))))
(assert (= g2 ((_ str.extract 2) x (re.from.ecma2020 'abc([a-z]+)([A-Z]+)'))))

(check-sat)
