(set-logic QF_S)

(set-info :status sat)

(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)
(declare-fun d () String)

(assert (= a (str.++ b (str.++ (str.++ c c) b))))
(assert (= b (str.++ d c)))

(assert (str.in.re a (re.+ (re.++ (str.to.re "x")
                                  (re.++ (re.* (str.to.re "z"))
                                         (re.* (str.to.re "y")))))))
(assert (str.in.re c (re.+ (str.to.re "x"))))

(check-sat)
(get-model)
