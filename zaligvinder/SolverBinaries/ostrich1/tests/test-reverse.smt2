(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)

(assert (= a (str.reverse b)))

(assert (str.in.re a (str.to.re "abcd")))
(assert (str.in.re b (str.to.re "dcba")))

(check-sat)
