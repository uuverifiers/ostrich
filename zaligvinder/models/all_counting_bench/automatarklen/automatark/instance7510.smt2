(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(^(100{1,1}$)|^(100{1,1}\.[0]+?$))|(^([0]*\d{0,2}$)|^([0]*\d{0,2}\.(([0][1-9]{1,1}[0]*)|([1-9]{1,1}[0]*)|([0]*)|([1-9]{1,2}[0]*)))$)$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.* (str.to_re "0")) (re.++ ((_ re.loop 1 2) (re.range "1" "9")) (re.* (str.to_re "0")))))) (str.to_re "\u{0a}")) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0")) (str.to_re ".") (re.+ (str.to_re "0"))))))
; ^([0-9]|0[0-9]|1[0-9]|2[0-3]):([0-9]|[0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.union (re.range "0" "9") (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ([^_.]([a-zA-Z0-9_]*[.]?[a-zA-Z0-9_]+[^_]){2})@([a-z0-9]+[.]([a-z]{2,3}|[a-z]{2,3}[.][a-z]{2,3}))
(assert (str.in_re X (re.++ (str.to_re "@\u{0a}") (re.union (str.to_re "_") (str.to_re ".")) ((_ re.loop 2 2) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (re.comp (str.to_re "_")))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") (re.union ((_ re.loop 2 3) (re.range "a" "z")) (re.++ ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")))))))
; \d{10,12}@[a-zA-Z].[a-zA-Z].*
(assert (str.in_re X (re.++ ((_ re.loop 10 12) (re.range "0" "9")) (str.to_re "@") (re.union (re.range "a" "z") (re.range "A" "Z")) re.allchar (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* re.allchar) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
