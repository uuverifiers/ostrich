(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^0[23489]{1}(\-)?[^0\D]{1}\d{6}$
(assert (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[0-9]+\.?[0-9]?[0-9]?[0,5]?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.union (str.to_re "0") (str.to_re ",") (str.to_re "5"))) (str.to_re "\u{0a}"))))
; ^(([A-Z]{1,2}[0-9]{1,2})|([A-Z]{1,2}[0-9][A-Z]))\s?([0-9][A-Z]{2})$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.range "A" "Z"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))))))
; /\/loader\.cpl$/U
(assert (str.in_re X (str.to_re "//loader.cpl/U\u{0a}")))
; /^[a-zA-Z0-9]+$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
