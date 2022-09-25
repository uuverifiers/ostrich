(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)
(declare-const m String)
(declare-const n String)



(assert (not (str.in.re x (re.* (str.to.re "abc") ) ) ) )
(assert (= x "abc") )


(check-sat)
(get-model)

