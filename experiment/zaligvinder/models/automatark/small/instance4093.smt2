(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\b\d{2,3}-*\d{7}\b$
(assert (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.* (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
