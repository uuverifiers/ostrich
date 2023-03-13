(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Send=\s+User-Agent\x3A\s+LoginHost\u{3a}\x2Ffriendship\x2Femail_thank_you\?Host\u{3a}CenterSubject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Send=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "LoginHost:/friendship/email_thank_you?Host:CenterSubject:\u{0a}")))))
; /name\u{3d}screenshot\d+\u{2e}/i
(assert (not (str.in_re X (re.++ (str.to_re "/name=screenshot") (re.+ (re.range "0" "9")) (str.to_re "./i\u{0a}")))))
; SpywareStrike.*Subject\x3A\s+Pcast\x2Edat\x2EToolbar
(assert (str.in_re X (re.++ (str.to_re "SpywareStrike") (re.* re.allchar) (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Pcast.dat.Toolbar\u{0a}"))))
; [\w-]+@([\w-]+\.)+[\w-]+
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^[0-9]{4} {0,1}[A-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
(check-sat)
