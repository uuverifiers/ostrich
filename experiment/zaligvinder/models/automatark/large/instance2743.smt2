(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z.\s']{1,50})$
(assert (str.in_re X (re.++ ((_ re.loop 1 50) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re ".") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}smi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smi/i\u{0a}"))))
; ((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.opt (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")))) (re.range "0" "9"))) (str.to_re "."))) (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.opt (re.union (re.++ (str.to_re "2") (re.range "0" "4")) (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")))) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^([a-zA-z]:((\\([-*\.*\w+\s+\d+]+)|(\w+)\\)+)(\w+.zip)|(\w+.ZIP))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "z")) (str.to_re ":") (re.+ (re.union (re.++ (str.to_re "\u{5c}") (re.+ (re.union (str.to_re "-") (str.to_re "*") (str.to_re ".") (str.to_re "+") (re.range "0" "9") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{5c}")))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) re.allchar (str.to_re "zip")) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) re.allchar (str.to_re "ZIP"))) (str.to_re "\u{0a}")))))
(check-sat)
