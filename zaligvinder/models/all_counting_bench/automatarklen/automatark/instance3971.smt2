(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?\d+(\.\d+)?|[-+]?\.\d+?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^[-+]?\d+(\.\d{2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /\u{2f}[\w\u{2d}]*\u{2e}\u{2e}$/mU
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.* (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "../mU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
