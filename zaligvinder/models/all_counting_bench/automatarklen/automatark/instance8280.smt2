(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; configINTERNAL\.ini.*SecureNet\s+User-Agent\x3Aregister\.asp
(assert (not (str.in_re X (re.++ (str.to_re "configINTERNAL.ini") (re.* re.allchar) (str.to_re "SecureNet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:register.asp\u{0a}")))))
; ^((([+])?[1])?\s{0,1}\d{3}\s{0,1}\d{3}\s{0,1}\d{4})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "1"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))))
; ^\b(29[0-9]|2[0-9][0-9]|[01]?[0-9][0-9]?)\\/(29[0-9]|2[0-9][0-9]|[01]?[0-9][0-9]?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "29") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{5c}/") (re.union (re.++ (str.to_re "29") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \x2Fcgi\x2Flogurl\.cgi.*User-Agent\x3A.*Host\x3Awww\x2EZSearchResults\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "/cgi/logurl.cgi") (re.* re.allchar) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:www.ZSearchResults.com\u{13}\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
