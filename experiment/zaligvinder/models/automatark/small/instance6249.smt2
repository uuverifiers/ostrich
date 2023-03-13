(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (CY-?)?[0-9]{8}[A-Z]
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "CY") (re.opt (str.to_re "-")))) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "Z") (str.to_re "\u{0a}"))))
; ^[0-9]*(\.)?[0-9]+$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
