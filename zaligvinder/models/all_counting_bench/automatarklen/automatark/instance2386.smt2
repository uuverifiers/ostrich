(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\(\d{2}\)?\s?|\d{2}(\-|\s))?\d{2,4}(\-|\s)?\d{4,5}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 2 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
