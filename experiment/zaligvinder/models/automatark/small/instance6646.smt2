(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/DES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (str.in_re X (re.++ (str.to_re "//DES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}"))))
; Apofis.*Port\x2E\s+\x2FNFO\x2CRegistered
(assert (str.in_re X (re.++ (str.to_re "Apofis") (re.* re.allchar) (str.to_re "Port.") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/NFO,Registered\u{0a}"))))
; Toolbar\d+Host\x3A\d+4\u{2e}8\u{2e}4\x7D\x7BTrojan\x3Aare
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "4.8.4}{Trojan:are\u{0a}"))))
; \.bmp[^\n\r]*couponbar\.coupons\.com.*Host\x3AHost\u{3a}HTTPwww
(assert (not (str.in_re X (re.++ (str.to_re ".bmp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "couponbar.coupons.com") (re.* re.allchar) (str.to_re "Host:Host:HTTPwww\u{0a}")))))
; httphostHost\u{3a}Agent\u{22}
(assert (not (str.in_re X (str.to_re "httphostHost:Agent\u{22}\u{0a}"))))
(check-sat)
