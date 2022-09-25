(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)
(declare-const m String)
(declare-const n String)



(assert (str.in.re (str.++ x y) (re.* (str.to.re "abc") ) ) )





(check-sat)
(get-model)

