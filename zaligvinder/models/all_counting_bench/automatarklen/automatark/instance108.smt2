(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; u=with\x3AHBand,Deathhoroscope2
(assert (str.in_re X (str.to_re "u=with:HBand,Deathhoroscope2\u{0a}")))
; (25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?|[0])\.(25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?|[0])\.(25[0-5]|2[0-4][0-9]|[1][0-9]?[0-9]?|[1-9][0-9]?)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")))) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (str.to_re "0")) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (str.to_re "0")) (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; upgrade\x2Eqsrch\x2Einfo[^\n\r]*dcww\x2Edmcast\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "dcww.dmcast.com\u{0a}"))))
; ^(X(-|\.)?0?\d{7}(-|\.)?[A-Z]|[A-Z](-|\.)?\d{7}(-|\.)?[0-9A-Z]|\d{8}(-|\.)?[A-Z])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "X") (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.opt (str.to_re "0")) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
