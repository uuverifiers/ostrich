(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9.\-/+() ]{4,}
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))))))
; ^\.{0,2}[\/\\]
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (str.to_re ".")) (re.union (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "\u{0a}"))))
; FTPHost\x3AUser-Agent\u{3a}User\x3AdistID=deskwizz\x2Ecom
(assert (str.in_re X (str.to_re "FTPHost:User-Agent:User:distID=deskwizz.com\u{0a}")))
; cyber@yahoo\x2Ecomconfig\x2E180solutions\x2Ecom
(assert (not (str.in_re X (str.to_re "cyber@yahoo.comconfig.180solutions.com\u{0a}"))))
(check-sat)
