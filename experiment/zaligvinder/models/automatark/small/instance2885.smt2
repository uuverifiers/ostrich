(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+)?[1-9]{1,2})?([-\s\.])?((\(\d{1,4}\))|\d{1,4})(([-\s\.])?[0-9]{1,12}){1,2}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 2) (re.range "1" "9")))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "(") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 1 4) (re.range "0" "9"))) ((_ re.loop 1 2) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 12) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /^[oz]/Ri
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "o") (str.to_re "z")) (str.to_re "/Ri\u{0a}")))))
; /\u{2e}ses([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ses") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; [A-Za-z_.0-9-]+@{1}[a-z]+([.]{1}[a-z]{2,4})+
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (str.to_re "-"))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.range "a" "z")) (re.+ (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.range "a" "z")))) (str.to_re "\u{0a}"))))
; %3fc=UI2GmbHbacktrust\x2EcomSpediaReferer\x3ASubject\u{3a}Host\u{3a}passcorrect\x3B
(assert (str.in_re X (str.to_re "%3fc=UI2GmbHbacktrust.comSpediaReferer:Subject:Host:passcorrect;\u{0a}")))
(check-sat)
