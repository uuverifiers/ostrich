(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(5[1-5]\d{2})\d{12}|(4\d{3})(\d{12}|\d{9})$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "5") (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 9 9) (re.range "0" "9"))) (str.to_re "\u{0a}4") ((_ re.loop 3 3) (re.range "0" "9"))))))
; /\u{2e}kvl([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.kvl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
