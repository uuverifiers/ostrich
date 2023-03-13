(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wk4/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wk4/i\u{0a}"))))
; [\d+]{10}\@[\w]+\.?[\w]+?\.?[\w]+?\.?[\w+]{2,4}/i
(assert (not (str.in_re X (re.++ ((_ re.loop 10 10) (re.union (re.range "0" "9") (str.to_re "+"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) ((_ re.loop 2 4) (re.union (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/i\u{0a}")))))
; [^A-Za-z0-9]
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (http://|)(www\.)?([^\.]+)\.(\w{2}|(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum))$
(assert (not (str.in_re X (re.++ (str.to_re "http://") (re.opt (str.to_re "www.")) (re.+ (re.comp (str.to_re "."))) (str.to_re ".") (re.union ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com") (str.to_re "net") (str.to_re "org") (str.to_re "edu") (str.to_re "int") (str.to_re "mil") (str.to_re "gov") (str.to_re "arpa") (str.to_re "biz") (str.to_re "aero") (str.to_re "name") (str.to_re "coop") (str.to_re "info") (str.to_re "pro") (str.to_re "museum")) (str.to_re "\u{0a}")))))
(check-sat)
