(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(^(100{1,1}$)|^(100{1,1}\.[0]+?$))|(^([0]*\d{0,2}$)|^([0]*\d{0,2}\.(([0][1-9]{1,1}[0]*)|([1-9]{1,1}[0]*)|([0]*)|([1-9]{1,2}[0]*)))$)$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.* (str.to_re "0")) (re.++ ((_ re.loop 1 2) (re.range "1" "9")) (re.* (str.to_re "0")))))) (str.to_re "\u{0a}")) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0")) (str.to_re ".") (re.+ (str.to_re "0"))))))
; ^([a-zA-Z].*|[1-9].*|[:./].*)\.(((a|A)(s|S)(p|P)(x|X)))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* re.allchar)) (re.++ (re.range "1" "9") (re.* re.allchar)) (re.++ (re.union (str.to_re ":") (str.to_re ".") (str.to_re "/")) (re.* re.allchar))) (str.to_re ".\u{0a}") (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "x") (str.to_re "X")))))
; ^[0][1-9]{2}(-)[0-9]{8}$  and  ^[0][1-9]{3}(-)[0-9]{7}$  and  ^[0][1-9]{4}(-)[0-9]{6}$
(assert (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "  and  0") ((_ re.loop 3 3) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "  and  0") ((_ re.loop 4 4) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
