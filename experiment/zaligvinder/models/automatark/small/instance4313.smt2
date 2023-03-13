(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Cookie\u{3a}\s+\x2FGRSI\|Server\|Host\x3Aorigin\x3Dsidefind
(assert (not (str.in_re X (re.++ (str.to_re "Cookie:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/GRSI|Server|\u{13}Host:origin=sidefind\u{0a}")))))
; ^(\d{1,2})(\s?(H|h)?)(:([0-5]\d))?$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "H") (str.to_re "h"))))))
(check-sat)
