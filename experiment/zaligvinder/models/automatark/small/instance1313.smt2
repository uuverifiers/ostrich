(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(\u{75}|\u{2d}|\u{2f}|\u{73}|\u{a2}|\u{2e}|\u{24}|\u{74})/sR
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "u") (str.to_re "-") (str.to_re "/") (str.to_re "s") (str.to_re "\u{a2}") (str.to_re ".") (str.to_re "$") (str.to_re "t")) (str.to_re "/sR\u{0a}"))))
; ^\.{1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ".")) (str.to_re "\u{0a}"))))
; /^dns\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/dns|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; /\x2Fdirect\.php\x3Ff=[0-9]{8}\u{26}s=[a-z0-9]{3}\.[a-z]{1,4}/U
(assert (str.in_re X (re.++ (str.to_re "//direct.php?f=") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "&s=") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
(check-sat)
