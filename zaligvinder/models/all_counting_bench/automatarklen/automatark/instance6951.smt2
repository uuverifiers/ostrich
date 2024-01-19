(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-z]?\d{8}[A-z]$
(assert (not (str.in_re X (re.++ (re.opt (re.range "A" "z")) ((_ re.loop 8 8) (re.range "0" "9")) (re.range "A" "z") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
