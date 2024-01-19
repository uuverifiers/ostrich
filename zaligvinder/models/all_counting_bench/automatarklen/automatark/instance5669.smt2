(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")) (re.* (re.++ (re.* (re.union (str.to_re "-") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.* (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (str.to_re "."))) ((_ re.loop 2 9) (re.union (re.range "a" "z") (re.range "A" "Z")))))))
(assert (> (str.len X) 10))
(check-sat)
