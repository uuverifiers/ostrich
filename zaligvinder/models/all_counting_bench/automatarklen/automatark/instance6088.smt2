(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(6334)[5-9](\d{11}$|\d{13,14}$))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}6334") (re.range "5" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 14) (re.range "0" "9")))))))
; DA\dwww\x2Ee-finder\x2Ecc.*User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "DA") (re.range "0" "9") (str.to_re "www.e-finder.cc") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}")))))
; \x2Ehtml\s+IDENTIFYwww\x2Eccnnlc\x2Ecomfilename=\u{22}Referer\x3A
(assert (not (str.in_re X (re.++ (str.to_re ".html") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFYwww.ccnnlc.com\u{13}filename=\u{22}Referer:\u{0a}")))))
; /\u{2e}pub([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pub") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; BV_SessionID=@@@@0106700396.1206001747@@@@&BV_EngineID=ccckadedjddehggcefecehidfhfdflg.0
(assert (str.in_re X (re.++ (str.to_re "BV_SessionID=@@@@0106700396") re.allchar (str.to_re "1206001747@@@@&BV_EngineID=ccckadedjddehggcefecehidfhfdflg") re.allchar (str.to_re "0\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
