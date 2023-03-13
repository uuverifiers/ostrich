(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (NL-?)?[0-9]{9}B[0-9]{2}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "NL") (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "B") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Subject\u{3a}SpywareSpyBuddy
(assert (str.in_re X (str.to_re "Subject:SpywareSpyBuddy\u{0a}")))
; /\.background\s*=\s*[\u{22}\u{27}]{2}/i
(assert (str.in_re X (re.++ (str.to_re "/.background") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/i\u{0a}"))))
(check-sat)
