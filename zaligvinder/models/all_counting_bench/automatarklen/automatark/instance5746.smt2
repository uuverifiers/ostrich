(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
