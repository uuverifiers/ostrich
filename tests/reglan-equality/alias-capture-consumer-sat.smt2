(set-logic QF_S)
(set-info :status sat)

(declare-const r RegLan)
(declare-const captured String)

(assert (= r (str.to_re "a")))
(assert (= captured ((_ str.extract 1) "a" ((_ re.capture 1) r))))
(assert (= captured "a"))

(check-sat)
