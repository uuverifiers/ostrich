(set-logic QF_S)

(declare-const x String)
(declare-const y String)

(assert (= y ((_ str.extract 1) x
              ((_ re.capture 1) (re.+ (str.to.re "a"))))))

(assert (str.in.re x (str.to.re "aab")))
;(assert (str.in.re y (str.to.re "")))

(check-sat)
(get-model)
