(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{5}(-[0-9]{4})?$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{2e}j2k([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.j2k") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(\(\d{3}\)|\d{3})[\s.-]?\d{3}[\s.-]?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[a-z0-9!$'*+\-_]+(\.[a-z0-9!$'*+\-_]+)*@([a-z0-9]+(-+[a-z0-9]+)*\.)+([a-z]{2}|aero|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|travel)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "$") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "$") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "-") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.* (re.++ (re.+ (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "."))) (re.union ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "aero") (str.to_re "arpa") (str.to_re "biz") (str.to_re "cat") (str.to_re "com") (str.to_re "coop") (str.to_re "edu") (str.to_re "gov") (str.to_re "info") (str.to_re "int") (str.to_re "jobs") (str.to_re "mil") (str.to_re "mobi") (str.to_re "museum") (str.to_re "name") (str.to_re "net") (str.to_re "org") (str.to_re "pro") (str.to_re "travel")) (str.to_re "\u{0a}")))))
; wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
