(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{4,4}[A-Z0-9]$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
