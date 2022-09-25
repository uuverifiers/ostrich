(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (str.to.re ".") ) ) ) 

(assert (= 5 (str.len x)))

(assert (not (= x ".....")))




(check-sat)
(get-model)

