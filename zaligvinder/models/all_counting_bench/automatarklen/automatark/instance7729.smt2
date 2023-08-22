(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0\.|([1-9]([0-9]+)?)\.){3}(0|([1-9]([0-9]+)?)){1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (str.to_re "0.") (re.++ (str.to_re ".") (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.opt (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; ^0?(5[024])(\-)?\d{7}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "0")) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}5") (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4")))))
(assert (> (str.len X) 10))
(check-sat)
