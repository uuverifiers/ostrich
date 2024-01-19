(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}rmp([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rmp") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; (^(5[0678])\d{11,18}$)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 18) (re.range "0" "9")) (str.to_re "5") (re.union (str.to_re "0") (str.to_re "6") (str.to_re "7") (str.to_re "8"))))))
; %3fSupremeSoftwareoffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "%3fSupremeSoftwareoffers.bullseye-network.com\u{0a}"))))
; ^[a-z0-9!$'*+\-_]+(\.[a-z0-9!$'*+\-_]+)*@([a-z0-9]+(-+[a-z0-9]+)*\.)+([a-z]{2}|aero|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|travel)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "$") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "$") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (re.+ (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "."))) (re.union ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "aero") (str.to_re "arpa") (str.to_re "biz") (str.to_re "cat") (str.to_re "com") (str.to_re "coop") (str.to_re "edu") (str.to_re "gov") (str.to_re "info") (str.to_re "int") (str.to_re "jobs") (str.to_re "mil") (str.to_re "mobi") (str.to_re "museum") (str.to_re "name") (str.to_re "net") (str.to_re "org") (str.to_re "pro") (str.to_re "travel")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
