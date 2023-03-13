(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((0[1-9])|(1[0-9])|(2[0-9])|(3[0]))/((0[1-9])|(1[0-2]))/14[3-9]{2}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (str.to_re "30")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/14") ((_ re.loop 2 2) (re.range "3" "9")) (str.to_re "\u{0a}"))))
(check-sat)
