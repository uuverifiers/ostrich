(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[1-9]\d{7,8}$
(assert (not (str.in_re X (re.++ (str.to_re "0") (re.range "1" "9") ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; <!--[\\.|\\W|\\w]*?-->
(assert (not (str.in_re X (re.++ (str.to_re "<!--") (re.* (re.union (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "|") (str.to_re "W") (str.to_re "w"))) (str.to_re "-->\u{0a}")))))
; ^\$[0-9]+(\.[0-9][0-9])?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Host\x3A\s+Host\x3A\u{7c}roogoo\u{7c}Testiufilfwulmfi\u{2f}riuf\.lio
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:|roogoo|Testiufilfwulmfi/riuf.lio\u{0a}")))))
; ([^a-zA-Z0-9])
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
