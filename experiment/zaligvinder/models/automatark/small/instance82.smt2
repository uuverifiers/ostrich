(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{2,4}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
