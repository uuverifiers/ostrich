(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$[+-]?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(\.[0-9]{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \x0D\x0A\x0D\x0AAttached.*Host\x3A\s+ZC-Bridge
(assert (not (str.in_re X (re.++ (str.to_re "\u{0d}\u{0a}\u{0d}\u{0a}Attached") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ZC-Bridge\u{0a}")))))
; ^[0-9]{4}-(((0[13578]|(10|12))-(0[1-9]|[1-2][0-9]|3[0-1]))|(02-(0[1-9]|[1-2][0-9]))|((0[469]|11)-(0[1-9]|[1-2][0-9]|30)))$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1")))) (re.++ (str.to_re "02-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11")) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
