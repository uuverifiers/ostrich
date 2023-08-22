(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]{4}[A-Z]{2}
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
