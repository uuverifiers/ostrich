(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (077|078|079)\s?\d{2}\s?\d{6}
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}07") (re.union (str.to_re "7") (str.to_re "8") (str.to_re "9")))))
(check-sat)
