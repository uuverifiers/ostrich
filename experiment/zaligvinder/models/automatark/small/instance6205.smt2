(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\x3AHost\u{3a}Host\x3A000Filelogin_ok\x5EMiniCommand
(assert (not (str.in_re X (str.to_re "Subject:Host:Host:000Filelogin_ok^MiniCommand\u{0a}"))))
; \.bmp[^\n\r]*couponbar\.coupons\.com.*Host\x3AHost\u{3a}HTTPwww
(assert (str.in_re X (re.++ (str.to_re ".bmp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "couponbar.coupons.com") (re.* re.allchar) (str.to_re "Host:Host:HTTPwww\u{0a}"))))
; \b[1-9]\d{3}\ +[A-Z]{2}\b
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9")) (re.+ (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; SpywareinformationToolBarX-Mailer\u{3a}User-Agent\x3AMM_RECO\x2EEXE
(assert (not (str.in_re X (str.to_re "SpywareinformationToolBarX-Mailer:\u{13}User-Agent:MM_RECO.EXE\u{0a}"))))
; ([A-Za-z0-9]+:\/\/)?([a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?(\/|(\/([A-Za-z0-9\:@!\$&'\(\}\*\+\-_,;=~\.]+|(%[A-F0-9]{2})+))*)(\?[A-Za-z0-9]+=[A-Za-z0-9]+(&[A-Za-z0-9]+=[A-Za-z0-9]+)*)?
(assert (str.in_re X (re.++ (re.opt (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "://"))) (re.opt (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))) (re.union (str.to_re "/") (re.* (re.++ (str.to_re "/") (re.union (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re ":") (str.to_re "@") (str.to_re "!") (str.to_re "$") (str.to_re "&") (str.to_re "'") (str.to_re "(") (str.to_re "}") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_") (str.to_re ",") (str.to_re ";") (str.to_re "=") (str.to_re "~") (str.to_re "."))) (re.+ (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "A" "F") (re.range "0" "9"))))))))) (re.opt (re.++ (str.to_re "?") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (str.to_re "&") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re "\u{0a}"))))
(check-sat)
