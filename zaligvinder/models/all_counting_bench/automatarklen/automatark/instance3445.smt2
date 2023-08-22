(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?\d+([.,]\d{0,2}){0,1}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
