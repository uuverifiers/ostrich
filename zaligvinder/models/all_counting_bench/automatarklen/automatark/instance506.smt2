(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^([a-zA-Z0-9\.\_\-\&]+)@[a-zA-Z0-9]+\.[a-zA-Z]{3}|(.[a-zA-Z]{2}(\.[a-zA-Z]{2}))$/
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-") (str.to_re "&"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re "/\u{0a}") re.allchar ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))))))
(assert (> (str.len X) 10))
(check-sat)
