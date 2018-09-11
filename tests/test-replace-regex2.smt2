(set-logic QF_S)

(declare-fun x () String)
(declare-fun y () String)
(declare-fun z () String)

(assert (str.in.re y (str.to.re "010101")))
(assert (str.in.re z (str.to.re "c")))
(assert (= x (str.replaceallre y (re.* (str.to.re "01")) z)))
(assert (str.in.re x (str.to.re "cc")))

(check-sat)
