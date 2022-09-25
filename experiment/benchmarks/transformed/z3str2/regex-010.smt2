(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re "ab") ) ) )
(assert (str.in.re x (re.* (str.to.re "abab") ) ) )
(assert (str.in.re x (re.* (str.to.re "ababac") ) ) )


(check-sat)
(get-model)

