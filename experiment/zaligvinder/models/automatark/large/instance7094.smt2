(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ppcdomain\x2Eco\x2Euk.*Spy\-Locked\s+Exploiter\w+\x2Fr\x2Fkeys\x2FkeysS\u{3a}Users\u{5c}Iterenet
(assert (not (str.in_re X (re.++ (str.to_re "ppcdomain.co.uk") (re.* re.allchar) (str.to_re "Spy-Locked") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Exploiter") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/r/keys/keysS:Users\u{5c}Iterenet\u{0a}")))))
; /\u{2e}motn([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.motn") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /^\u{2f}[A-Za-z0-9+~=]{16,17}\u{2f}[A-Za-z0-9+~=]{35,40}\u{2f}[A-Za-z0-9+~=]{8}\u{2f}[A-Za-z0-9+~=]*?\u{2f}[A-Za-z0-9+~=]{12,30}$/I
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 16 17) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 35 40) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") (re.* (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/") ((_ re.loop 12 30) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "~") (str.to_re "="))) (str.to_re "/I\u{0a}")))))
(check-sat)
