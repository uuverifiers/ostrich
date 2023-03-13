(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[$]?[0-9]*(\.)?[0-9]?[0-9]?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\u{3a}\s+e2give\.com\s+NETObservemedia\x2Edxcdirect\x2EcomSubject\x3Aquick\x2Eqsrch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "NETObservemedia.dxcdirect.comSubject:quick.qsrch.com\u{0a}")))))
; 5[12345]\d{14}
(assert (str.in_re X (re.++ (str.to_re "5") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5")) ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
