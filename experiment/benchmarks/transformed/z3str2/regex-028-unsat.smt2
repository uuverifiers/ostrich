(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re "ab") ) ) )
(assert (str.in.re x (re.* (str.to.re "abab") ) ) )
(assert (str.in.re x (re.* (str.to.re "ababac") ) ) )

(assert (> (str.len x)  1) )

(check-sat)
(get-model)

