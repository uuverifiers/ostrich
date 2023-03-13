(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\(?\+45\)?)?)(\s?\d{2}\s?\d{2}\s?\d{2}\s?\d{2})$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (str.to_re "+45") (re.opt (str.to_re ")")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9"))))))
; ^(([+]|00)39)?((3[1-6][0-9]))(\d{7})$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) (str.to_re "39"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}3") (re.range "1" "6") (re.range "0" "9"))))
; User-Agent\x3AServerHost\x3A
(assert (str.in_re X (str.to_re "User-Agent:ServerHost:\u{0a}")))
(check-sat)
