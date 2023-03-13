(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[6]\d{7}$
(assert (str.in_re X (re.++ (str.to_re "6") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}jpx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jpx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; onBetaHost\u{3a}youRootReferer\x3A
(assert (not (str.in_re X (str.to_re "onBetaHost:youRootReferer:\u{0a}"))))
; ^(9|2{1})+([1-9]{1})+([0-9]{7})$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "9") ((_ re.loop 1 1) (str.to_re "2")))) (re.+ ((_ re.loop 1 1) (re.range "1" "9"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
