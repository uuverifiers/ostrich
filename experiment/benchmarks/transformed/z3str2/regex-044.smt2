(set-logic QF_S)
(set-info :status sat)

(declare-const x String)
(declare-const y String)
(declare-const m String)
(declare-const n String)



(assert (str.in.re x (re.* (re.range "0" "9") ) ) )

(assert (= 1 (str.len x) ) )

(assert (not (= x "1") ) )
(assert (not (= x "0") ) )
(assert (not (= x "3") ) )
(assert (not (= x "2") ) )
(assert (not (= x "8") ) )
; (assert (not (= x "5") ) )
(assert (not (= x "6") ) )
(assert (not (= x "4") ) )
(assert (not (= x "9") ) )
(assert (not (= x "7") ) )






(check-sat)
(get-model)

