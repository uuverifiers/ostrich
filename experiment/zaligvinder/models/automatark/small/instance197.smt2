(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((18[5-9][0-9])|((19|20)[0-9]{2})|(2100))$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "18") (re.range "5" "9") (re.range "0" "9")) (re.++ (re.union (str.to_re "19") (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "2100")) (str.to_re "\u{0a}"))))
(check-sat)
