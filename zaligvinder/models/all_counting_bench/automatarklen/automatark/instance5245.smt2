(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\([2-9]|[2-9])(\d{2}|\d{2}\))(-|.|\s)?\d{3}(-|.|\s)?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.range "2" "9")) (re.range "2" "9")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")"))) (re.opt (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
