(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; si=\s+ProAgent\s+Subject\x3Aas\x2Estarware\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "si=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ProAgent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:as.starware.com\u{0a}"))))
; ^0?[0-9]?[0-9]$|^(100)$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "0")) (re.opt (re.range "0" "9")) (re.range "0" "9")) (str.to_re "100\u{0a}")))))
; /\/14\d{8}(.jar)?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//14") ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.++ re.allchar (str.to_re "jar"))) (str.to_re "/U\u{0a}")))))
(check-sat)
