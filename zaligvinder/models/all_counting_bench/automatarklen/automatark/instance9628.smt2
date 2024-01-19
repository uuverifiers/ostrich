(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\dName=Your\+Host\+is\x3A.*has\s+ComputerKeylogger\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:") (re.* re.allchar) (str.to_re "has") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ComputerKeylogger.comHost:\u{0a}")))))
; [\w]+\@[\w]+\.?[\w]+?\.?[\w]+?\.?[\w+]{2,4}
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re ".")) ((_ re.loop 2 4) (re.union (str.to_re "+") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^([A-Za-z]\d[A-Za-z][-]?\d[A-Za-z]\d)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (str.to_re "-")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")))))
; /\u{2f}ib2\u{2f}$/U
(assert (str.in_re X (str.to_re "//ib2//U\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
