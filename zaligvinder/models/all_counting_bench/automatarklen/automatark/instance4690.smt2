(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{3}\d{8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
