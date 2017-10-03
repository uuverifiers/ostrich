(set-logic QF_S)


(declare-fun x () String)
(declare-fun y () String)

(assert (= x "\x48\145\x6cl\o"))

;unsat
(assert (str.in.re x (re.* (re.range "a" "u"))))
(check-sat)

(check-sat)
