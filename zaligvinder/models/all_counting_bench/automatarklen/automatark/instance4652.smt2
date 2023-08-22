(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}hpj([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.hpj") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \d{10,12}@[a-zA-Z].[a-zA-Z].*
(assert (str.in_re X (re.++ ((_ re.loop 10 12) (re.range "0" "9")) (str.to_re "@") (re.union (re.range "a" "z") (re.range "A" "Z")) re.allchar (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* re.allchar) (str.to_re "\u{0a}"))))
; ChildWebGuardian\d+Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "ChildWebGuardian") (re.+ (re.range "0" "9")) (str.to_re "Subject:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
