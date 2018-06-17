(set-logic QF_S)

(set-info :status unsat)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= a (str.++ b c)))
(assert (= b (str.++ d c)))

(assert (str.in.re a (re.+ (str.to.re "y"))))
(assert (str.in.re c (re.+ (str.to.re "x"))))

(check-sat)
(get-model)
