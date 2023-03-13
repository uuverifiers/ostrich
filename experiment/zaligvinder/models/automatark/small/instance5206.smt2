(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; URL\s+url=Host\u{3a}httpUser-Agent\x3ASubject\x3A
(assert (str.in_re X (re.++ (str.to_re "URL") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "url=Host:httpUser-Agent:Subject:\u{0a}"))))
; \.bmp[^\n\r]*couponbar\.coupons\.com.*Host\x3AHost\u{3a}HTTPwww
(assert (str.in_re X (re.++ (str.to_re ".bmp") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "couponbar.coupons.com") (re.* re.allchar) (str.to_re "Host:Host:HTTPwww\u{0a}"))))
; /^Subject\x3A[^\r\n]*Trojaner-Info\sNewsletter/smi
(assert (str.in_re X (re.++ (str.to_re "/Subject:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "Trojaner-Info") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Newsletter/smi\u{0a}"))))
; ^([A-Za-z]|[A-Za-z][0-9]*|[0-9]*[A-Za-z])+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(check-sat)
