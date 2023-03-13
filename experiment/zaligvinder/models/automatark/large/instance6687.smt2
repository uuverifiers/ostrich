(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[a-z]\u{3d}[a-f\d]{80,140}$/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 80 140) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Pi\u{0a}")))))
; forum=\s+\x2Ftoolbar\x2Fico\x2F
(assert (not (str.in_re X (re.++ (str.to_re "forum=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}")))))
(check-sat)
