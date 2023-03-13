(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{10,12}@[a-zA-Z].[a-zA-Z].*
(assert (not (str.in_re X (re.++ ((_ re.loop 10 12) (re.range "0" "9")) (str.to_re "@") (re.union (re.range "a" "z") (re.range "A" "Z")) re.allchar (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* re.allchar) (str.to_re "\u{0a}")))))
(check-sat)
