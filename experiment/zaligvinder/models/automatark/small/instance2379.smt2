(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}kills\u{2e}txt\u{3f}(t\d|p)\u{3d}\d{6}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//kills.txt?") (re.union (re.++ (str.to_re "t") (re.range "0" "9")) (str.to_re "p")) (str.to_re "=") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; st=\s+www\.iggsey\.com.*BackAtTaCkadserver\.warezclient\.com
(assert (str.in_re X (re.++ (str.to_re "st=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.com") (re.* re.allchar) (str.to_re "BackAtTaCkadserver.warezclient.com\u{0a}"))))
; Cookie\u{3a}.*Host\x3A.*ldap\x3A\x2F\x2F
(assert (str.in_re X (re.++ (str.to_re "Cookie:") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "ldap://\u{0a}"))))
(check-sat)
