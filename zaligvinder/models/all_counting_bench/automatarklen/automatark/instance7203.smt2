(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z][a-z]+((eir|(n|l)h)(a|o))$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.union (str.to_re "eir") (re.++ (re.union (str.to_re "n") (str.to_re "l")) (str.to_re "h"))) (re.union (str.to_re "a") (str.to_re "o"))))))
; ^[+-]? *(\$)? *((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{0,2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (re.opt (str.to_re "$")) (re.* (str.to_re " ")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Black\s+Warezxmlns\x3A%3flinkautomatici\x2EcomSubject\u{3a}Host\x3A
(assert (str.in_re X (re.++ (str.to_re "Black") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Warezxmlns:%3flinkautomatici.comSubject:Host:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
