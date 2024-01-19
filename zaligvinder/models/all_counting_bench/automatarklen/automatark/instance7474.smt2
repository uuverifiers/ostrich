(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (Word1|Word2).*?(10|[1-9])
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (str.to_re "10") (re.range "1" "9")) (str.to_re "\u{0a}Word") (re.union (str.to_re "1") (str.to_re "2"))))))
; to\d+User-Agent\x3AFiltered
(assert (str.in_re X (re.++ (str.to_re "to") (re.+ (re.range "0" "9")) (str.to_re "User-Agent:Filtered\u{0a}"))))
; ^(LDAP://([\w]+/)?(CN=['\w\s\-\&]+,)*(OU=['\w\s\-\&]+,)*(DC=['\w\s\-\&]+[,]*)+)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}LDAP://") (re.opt (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/"))) (re.* (re.++ (str.to_re "CN=") (re.+ (re.union (str.to_re "'") (str.to_re "-") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ","))) (re.* (re.++ (str.to_re "OU=") (re.+ (re.union (str.to_re "'") (str.to_re "-") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ","))) (re.+ (re.++ (str.to_re "DC=") (re.+ (re.union (str.to_re "'") (str.to_re "-") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (str.to_re ",")))))))
; (^(\d{2}\x2E\d{3}\x2E\d{3}[-]\d{1})$|^(\d{2}\x2E\d{3}\x2E\d{3})$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
