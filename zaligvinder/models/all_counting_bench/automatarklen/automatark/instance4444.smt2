(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [1-9][0-9]
(assert (str.in_re X (re.++ (re.range "1" "9") (re.range "0" "9") (str.to_re "\u{0a}"))))
; ^(9\d{2})([ \-]?)([7]\d|8[0-8])([ \-]?)(\d{4})$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (re.union (re.++ (str.to_re "7") (re.range "0" "9")) (re.++ (str.to_re "8") (re.range "0" "8"))) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}9") ((_ re.loop 2 2) (re.range "0" "9"))))))
; LOG\s+spyblini\x2EiniUpdateUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "LOG") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblini.iniUpdateUser-Agent:\u{0a}")))))
; /outerhtml\s*?\+\=\s*?\u{22}/i
(assert (str.in_re X (re.++ (str.to_re "/outerhtml") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "+=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}/i\u{0a}"))))
; ^((\(?\+45\)?)?)(\s?\d{2}\s?\d{2}\s?\d{2}\s?\d{2})$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (str.to_re "+45") (re.opt (str.to_re ")")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
