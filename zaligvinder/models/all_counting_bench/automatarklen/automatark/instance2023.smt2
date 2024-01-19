(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{10}$
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
