(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \A(([a-zA-Z]{1,2}\d{1,2})|([a-zA-Z]{2}\d[a-zA-Z]{1}))\u{20}{0,1}\d[a-zA-Z]{2}\Z
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.range "0" "9") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (str.to_re " ")) (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(check-sat)
