(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x2Fdirect\.php\x3Ff=[0-9]{8}\u{26}s=[a-z0-9]{3}\.[a-z]{1,4}/U
(assert (str.in_re X (re.++ (str.to_re "//direct.php?f=") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "&s=") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
; ^(\+[1-9]\d+) ([1-9]\d+) ([1-9]\d+)(\-\d+){0,1}$|^(0\d+) ([1-9]\d+)(\-\d+){0,1}$|^([1-9]\d+)(\-\d+){0,1}$
(assert (str.in_re X (re.union (re.++ (str.to_re "  ") (re.opt (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))) (str.to_re "+") (re.range "1" "9") (re.+ (re.range "0" "9")) (re.range "1" "9") (re.+ (re.range "0" "9")) (re.range "1" "9") (re.+ (re.range "0" "9"))) (re.++ (str.to_re " ") (re.opt (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))) (str.to_re "0") (re.+ (re.range "0" "9")) (re.range "1" "9") (re.+ (re.range "0" "9"))) (re.++ (re.opt (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.range "1" "9") (re.+ (re.range "0" "9"))))))
; Subject\x3A\s+Host\x3A.*www\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "www.alfacleaner.com\u{0a}"))))
(check-sat)
