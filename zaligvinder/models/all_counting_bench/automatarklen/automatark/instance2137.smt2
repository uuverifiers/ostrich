(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9]+(-?[a-z0-9]+)?(\.[a-z0-9]+(-?[a-z0-9]+)?)*\.([a-z]{2}|xn\-{2}[a-z0-9]{4,18}|arpa|aero|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|xxx)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.++ (re.opt (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.++ (re.opt (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re ".") (re.union ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "xn") ((_ re.loop 2 2) (str.to_re "-")) ((_ re.loop 4 18) (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re "arpa") (str.to_re "aero") (str.to_re "asia") (str.to_re "biz") (str.to_re "cat") (str.to_re "com") (str.to_re "coop") (str.to_re "edu") (str.to_re "gov") (str.to_re "info") (str.to_re "int") (str.to_re "jobs") (str.to_re "mil") (str.to_re "mobi") (str.to_re "museum") (str.to_re "name") (str.to_re "net") (str.to_re "org") (str.to_re "pro") (str.to_re "tel") (str.to_re "travel") (str.to_re "xxx")) (str.to_re "\u{0a}")))))
; IPAnaloffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "IPAnaloffers.bullseye-network.com\u{0a}"))))
; ^((\+){1}91){1}[1-9]{1}[0-9]{9}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "91"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
