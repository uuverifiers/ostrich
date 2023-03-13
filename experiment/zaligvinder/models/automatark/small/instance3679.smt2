(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\s*\(?0\d{4}\)?\s*\d{6}\s*)|(\s*\(?0\d{3}\)?\s*\d{3}\s*\d{4}\s*)
(assert (str.in_re X (re.union (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "(")) (str.to_re "0") ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ (str.to_re "\u{0a}") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "(")) (str.to_re "0") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; /[A-F0-9]{8}(-[A-F0-9]{4}){3}-[A-F0-9]{12}.wipe$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "A" "F") (re.range "0" "9"))) ((_ re.loop 3 3) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "F") (re.range "0" "9"))))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "F") (re.range "0" "9"))) re.allchar (str.to_re "wipe/Ui\u{0a}")))))
; ^([0-7]{3})$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "7")) (str.to_re "\u{0a}")))))
(check-sat)
