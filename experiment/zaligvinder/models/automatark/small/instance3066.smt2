(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(a-z|A-Z|0-9)*[^#$%^&*()']*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "a-z") (str.to_re "A-Z") (str.to_re "0-9"))) (re.* (re.union (str.to_re "#") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "(") (str.to_re ")") (str.to_re "'"))) (str.to_re "\u{0a}"))))
; (^((((0[1-9])|([1-2][0-9])|(3[0-1]))|([1-9]))\x2F(((0[1-9])|(1[0-2]))|([1-9]))\x2F(([0-9]{2})|(((19)|([2]([0]{1})))([0-9]{2}))))$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "19") (re.++ (str.to_re "2") ((_ re.loop 1 1) (str.to_re "0")))) ((_ re.loop 2 2) (re.range "0" "9")))))))
(check-sat)
