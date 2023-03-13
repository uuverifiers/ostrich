(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]{1,3}\[([0-9]{1,3})\]
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "]\u{0a}"))))
; ^\$?\d+(\.(\d{2}))?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
