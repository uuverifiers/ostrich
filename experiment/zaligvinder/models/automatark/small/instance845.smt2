(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (((0[123456789]|10|11|12)(([1][9][0-9][0-9])|([2][0-9][0-9][0-9]))))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (str.to_re "10") (str.to_re "11") (str.to_re "12")) (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))))))
; jquery\-(\d|\.)*\.min\.js
(assert (not (str.in_re X (re.++ (str.to_re "jquery-") (re.* (re.union (re.range "0" "9") (str.to_re "."))) (str.to_re ".min.js\u{0a}")))))
; /sid=[0-9A-F]{32}/U
(assert (str.in_re X (re.++ (str.to_re "/sid=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/U\u{0a}"))))
(check-sat)
