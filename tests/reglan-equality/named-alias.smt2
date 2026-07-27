(set-logic QF_S)
(set-option :produce-unsat-cores true)

(declare-const r RegLan)

(assert (! (= r (str.to_re "a")) :named first-alias))
(assert (! (= r (str.to_re "b")) :named second-alias))

(check-sat)
