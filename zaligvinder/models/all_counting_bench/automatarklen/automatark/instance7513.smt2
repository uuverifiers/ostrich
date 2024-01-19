(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([\w\._-]){3,}\@([\w\-_.]){3,}\.(\w){2,4}$
(assert (str.in_re X (re.++ (str.to_re "@.") ((_ re.loop 2 4) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (str.to_re ".") (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re ".") (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; ^[A-Z]\d{2}(\.\d){0,1}$
(assert (str.in_re X (re.++ (re.range "A" "Z") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; iepluginBrowsedOVNHost\x3A\x2Fproducts\x2Fspyblocs\x2F
(assert (not (str.in_re X (str.to_re "iepluginBrowsedOVNHost:/products/spyblocs/\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
