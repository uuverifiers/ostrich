(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(5[0678])\d{11,18}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 18) (re.range "0" "9")) (str.to_re "5") (re.union (str.to_re "0") (str.to_re "6") (str.to_re "7") (str.to_re "8"))))))
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}")))))
; ^\d{3}-\d{2}-\d{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
