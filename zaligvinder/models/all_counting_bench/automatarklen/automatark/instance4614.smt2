(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^[0]{1}$|^[-]?[1-9]{1}\d*$)
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (str.to_re "0")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \x2Ephp\s+Host\x3Aorigin\x3Dsidefind\u{22}The
(assert (not (str.in_re X (re.++ (str.to_re ".php") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:origin=sidefind\u{22}The\u{0a}")))))
; /\u{2e}ani([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ani") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
