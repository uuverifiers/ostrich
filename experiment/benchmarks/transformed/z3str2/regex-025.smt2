(set-logic QF_S)
(set-info :status sat)
(declare-const x String)
(declare-const y String)


(assert (str.in.re x (re.* (re.++ (re.* (str.to.re "a") ) (str.to.re "b") ))))

(assert (str.in.re y (re.* (re.++ (re.* (str.to.re "a") ) (str.to.re "b") ))))
      
(assert (= (str.len x) (str.len y)))

(assert (not (= x y)))

(assert (= (str.len x) 7))






(check-sat)
(get-model)

