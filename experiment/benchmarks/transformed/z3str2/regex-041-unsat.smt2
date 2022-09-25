(set-logic QF_S)
(set-info :status unsat)
(declare-const x String)
(declare-const y String)
(declare-const m String)
(declare-const n String)



(assert (str.in.re x (re.++ (str.to.re "a") (re.* (str.to.re "b") ) ) ) )

(assert (str.in.re x (re.++ (str.to.re "c") (re.* (str.to.re "c") ) ) ) )

(assert (str.in.re x (re.++ (str.to.re "a") (re.++ (re.* (str.to.re "b") ) (re.* (str.to.re "c") ) ) ) ) )

;(assert (str.in.re s (re.inter
;  (re.++ (str.to.re "a") (re.* (str.to.re "b")) 
;    (re.inter (str.to.re "c") (re.* (str.to.re "c"))))
;  (re.++ (str.to.re "a") (re.* (str.to.re "b")) (re.* (str.to.re "c")))
;  )))




(check-sat)
(get-model)

