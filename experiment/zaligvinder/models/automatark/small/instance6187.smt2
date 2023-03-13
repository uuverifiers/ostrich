(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]?\d+(\,\d{2})? *?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (str.to_re "\u{0a}")))))
; ^[-|\+]?[0-9]{1,3}(\,[0-9]{3})*$|^[-|\+]?[0-9]+$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; (")([0-9]*)(",")([0-9]*)("\))
(assert (not (str.in_re X (re.++ (str.to_re "\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22},\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22})\u{0a}")))))
(check-sat)
