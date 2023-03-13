(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-z]?\d{8}[A-z]$
(assert (not (str.in_re X (re.++ (re.opt (re.range "A" "z")) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "z") (str.to_re "\u{0a}")))))
; ^([0-9]*\,?[0-9]+|[0-9]+\,?[0-9]*)?$
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ",")) (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ",")) (re.* (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(check-sat)
