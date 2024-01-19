(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; \b(0?[1-9]|1[0-2])(\/)(0?[1-9]|1[0-9]|2[0-9]|3[0-1])(\/)(0[0-8])\b
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/\u{0a}0") (re.range "0" "8"))))
; ^(LDAP://([\w]+/)?(CN=['\w\s\-\&]+,)*(OU=['\w\s\-\&]+,)*(DC=['\w\s\-\&]+[,]*)+)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}LDAP://") (re.opt (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/"))) (re.* (re.++ (str.to_re "CN=") (re.+ (re.union (str.to_re "'") (str.to_re "-") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ","))) (re.* (re.++ (str.to_re "OU=") (re.+ (re.union (str.to_re "'") (str.to_re "-") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ","))) (re.+ (re.++ (str.to_re "DC=") (re.+ (re.union (str.to_re "'") (str.to_re "-") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (str.to_re ","))))))))
; ^([V|E|J|G|v|e|j|g])([0-9]{5,8})$
(assert (str.in_re X (re.++ (re.union (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G") (str.to_re "v") (str.to_re "e") (str.to_re "j") (str.to_re "g")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
