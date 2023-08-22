(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,3}'(\d{3}')*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "'") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "'"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; ([.])([a-z,1-9]{3,4})(\/)
(assert (not (str.in_re X (re.++ (str.to_re ".") ((_ re.loop 3 4) (re.union (re.range "a" "z") (str.to_re ",") (re.range "1" "9"))) (str.to_re "/\u{0a}")))))
; /^("(\\["\\]|[^"])*"|[^\n])*(\n|$)/gm
(assert (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (str.to_re "\u{0a}")))) (str.to_re "\u{0a}/gm\u{0a}"))))
; ^0[23489]{1}(\-)?[^0\D]{1}\d{6}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
