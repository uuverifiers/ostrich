(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z|a-z]{2}-\d{2}-[A-Z|a-z]{2}-\d{1,4})?([A-Z|a-z]{3}-\d{1,4})?$
(assert (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 1 4) (re.range "0" "9")))) (re.opt (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (str.to_re "|") (re.range "a" "z"))) (str.to_re "-") ((_ re.loop 1 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[^#]([^ ]+ ){6}[^ ]+$
(assert (str.in_re X (re.++ (re.comp (str.to_re "#")) ((_ re.loop 6 6) (re.++ (re.+ (re.comp (str.to_re " "))) (str.to_re " "))) (re.+ (re.comp (str.to_re " "))) (str.to_re "\u{0a}"))))
; ^\w*[-]*\w*\\\w*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (str.to_re "-")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{5c}") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; Host\x3A.*www\u{2e}2-seek\u{2e}com\u{2f}search
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "www.2-seek.com/search\u{0a}"))))
; ^[-+]?\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
