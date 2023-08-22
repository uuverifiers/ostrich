(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (:[a-z]{1}[a-z1-9\$#_]*){1,31}
(assert (str.in_re X (re.++ ((_ re.loop 1 31) (re.++ (str.to_re ":") ((_ re.loop 1 1) (re.range "a" "z")) (re.* (re.union (re.range "a" "z") (re.range "1" "9") (str.to_re "$") (str.to_re "#") (str.to_re "_"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
