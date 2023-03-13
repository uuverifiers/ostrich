(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\s*(([\w-]+\.)+[\w-]+|([a-zA-Z]{1}|[\w-]{2,}))@(\w+\.)+[A-Za-z]{2,5}$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.+ (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) ((_ re.loop 2 5) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; ^0(6[045679][0469]){1}(\-)?(1)?[^0\D]{1}\d{6}$
(assert (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.++ (str.to_re "6") (re.union (str.to_re "0") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "6") (str.to_re "9")))) (re.opt (str.to_re "-")) (re.opt (str.to_re "1")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}asx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}"))))
; LoginHost\u{3a}\x2Ffriendship\x2Femail_thank_you\?
(assert (not (str.in_re X (str.to_re "LoginHost:/friendship/email_thank_you?\u{0a}"))))
(check-sat)
