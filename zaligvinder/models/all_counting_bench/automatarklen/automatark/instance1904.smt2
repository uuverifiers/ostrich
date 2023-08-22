(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((ht|f)tp(s?))\://([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(/\S*)?$
(assert (not (str.in_re X (re.++ (str.to_re "://") (re.+ (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "-"))) (str.to_re "."))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}") (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s"))))))
; ^[0-9a-zA-Z]+([0-9a-zA-Z]*[-._+])*[0-9a-zA-Z]+@[0-9a-zA-Z]+([-.][0-9a-zA-Z]+)*([0-9a-zA-Z]*[.])[a-zA-Z]{2,6}$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "+")))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}") (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))))
; User-Agent\u{3a}Host\x3Apasswordhavewww\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (str.to_re "User-Agent:Host:passwordhavewww.alfacleaner.com\u{0a}")))
; /filename=[^\n]*\u{2e}pdf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pdf/i\u{0a}")))))
; /filename=[^\n]*\u{2e}docm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".docm/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
