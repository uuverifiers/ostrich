(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /((\d){2})?(\s|-)?((\d){2,4})?(\s|-){1}((\d){8})$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt ((_ re.loop 2 4) (re.range "0" "9"))) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}"))))
; ^(\d{5}-\d{4}|\d{5})$|^([a-zA-Z]\d[a-zA-Z] \d[a-zA-Z]\d)$
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re " ") (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")))))
; ^([01]\d|2[0123])([0-5]\d){2}([0-99]\d)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3")))) ((_ re.loop 2 2) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.union (re.range "0" "9") (str.to_re "9")) (re.range "0" "9"))))
(assert (> (str.len X) 10))
(check-sat)
