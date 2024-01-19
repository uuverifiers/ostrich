(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^number=[0-9A-F]{32}$/mC
(assert (str.in_re X (re.++ (str.to_re "/number=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/mC\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
