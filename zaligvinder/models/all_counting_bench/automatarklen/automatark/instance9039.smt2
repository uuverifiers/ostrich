(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re "+") (str.to_re ".") (str.to_re "'")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; ^\d{2,6}-\d{2}-\d$
(assert (str.in_re X (re.++ ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; (^(30)[0-5]\d{11}$)|(^(36)\d{12}$)|(^(38[0-8])\d{11}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "30") (re.range "0" "5") ((_ re.loop 11 11) (re.range "0" "9"))) (re.++ (str.to_re "36") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "38") (re.range "0" "8")))))
(assert (> (str.len X) 10))
(check-sat)
