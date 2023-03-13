(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \A([0-9a-zA-Z_]{1,15})|(@([0-9a-zA-Z_]{1,15}))\Z
(assert (not (str.in_re X (re.union ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.++ (str.to_re "\u{0a}@") ((_ re.loop 1 15) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))))))))
(check-sat)
