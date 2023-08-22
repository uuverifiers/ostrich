(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((5)/(1|2|5)/([0-9])/([0-9])/([0-9])/([0-9])/([0-9])/([0-9])/([2-9]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}5/") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "5")) (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "2" "9"))))
; ^(\+){0,1}\d{1,10}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 10) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\d+\.compress.*sidebar\.activeshopper\.com
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re ".compress") (re.* re.allchar) (str.to_re "sidebar.activeshopper.com\u{0a}"))))
; Host\x3A\s+Eyewww\x2Eccnnlc\x2EcomHost\u{3a}Host\u{3a}
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Eyewww.ccnnlc.com\u{13}Host:Host:\u{0a}"))))
; ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9]+(-?[a-z0-9]+)?(\.[a-z0-9]+(-?[a-z0-9]+)?)*\.([a-z]{2}|xn\-{2}[a-z0-9]{4,18}|arpa|aero|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|xxx)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.++ (re.opt (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.opt (re.++ (re.opt (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re ".") (re.union ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "xn") ((_ re.loop 2 2) (str.to_re "-")) ((_ re.loop 4 18) (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re "arpa") (str.to_re "aero") (str.to_re "asia") (str.to_re "biz") (str.to_re "cat") (str.to_re "com") (str.to_re "coop") (str.to_re "edu") (str.to_re "gov") (str.to_re "info") (str.to_re "int") (str.to_re "jobs") (str.to_re "mil") (str.to_re "mobi") (str.to_re "museum") (str.to_re "name") (str.to_re "net") (str.to_re "org") (str.to_re "pro") (str.to_re "tel") (str.to_re "travel") (str.to_re "xxx")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
