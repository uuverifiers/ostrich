(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A.*OSSProxy
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "OSSProxy\u{0a}")))))
; ^(([1-4][0-9])|(0[1-9])|(5[0-2]))\/[1-2]\d{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "4") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "5") (re.range "0" "2"))) (str.to_re "/") (re.range "1" "2") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[a-z0-9!$'*+\-_]+(\.[a-z0-9!$'*+\-_]+)*@([a-z0-9]+(-+[a-z0-9]+)*\.)+([a-z]{2}|aero|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|travel)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "$") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "$") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (re.+ (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "."))) (re.union ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "aero") (str.to_re "arpa") (str.to_re "biz") (str.to_re "cat") (str.to_re "com") (str.to_re "coop") (str.to_re "edu") (str.to_re "gov") (str.to_re "info") (str.to_re "int") (str.to_re "jobs") (str.to_re "mil") (str.to_re "mobi") (str.to_re "museum") (str.to_re "name") (str.to_re "net") (str.to_re "org") (str.to_re "pro") (str.to_re "travel")) (str.to_re "\u{0a}"))))
; ^([A-Z\d]{3})[A-Z]{2}\d{2}([A-Z\d]{1})([X\d]{1})([A-Z\d]{3})\d{5}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.union (str.to_re "X") (re.range "0" "9"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
