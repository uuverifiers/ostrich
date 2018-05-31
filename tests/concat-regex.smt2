(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= a (str.++ b c)))
(assert (= b (str.++ d c)))

(assert (str.in.re a (re.+ (re.union (str.to.re "0") (str.to.re "1")))))
(assert (str.in.re c (re.+ (str.to.re "0"))))

(check-sat)