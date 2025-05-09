(set-logic QF_S)

(declare-fun a () String)
(declare-fun b () String)

(assert (= a (str.++ b b)))
(assert (str.in.re a (re.++ (re.+ (str.to.re "("))
                            (re.+ (str.to.re ")")))))

(check-sat)

