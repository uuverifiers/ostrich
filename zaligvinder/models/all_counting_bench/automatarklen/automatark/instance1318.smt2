(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?(([1-9],)?([0-9]{3},){0,3}[0-9]{3}|[0-9]{0,16})(\.[0-9]{0,3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ (re.opt (re.++ (re.range "1" "9") (str.to_re ","))) ((_ re.loop 0 3) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 0 16) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Toolbar.*www\x2Ewebcruiser\x2Ecc\w+www\x2Etopadwarereviews\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* re.allchar) (str.to_re "www.webcruiser.cc") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.com\u{0a}"))))
; ^100$|^[0-9]{1,2}$|^[0-9]{1,2}\,[0-9]{1,3}$
(assert (str.in_re X (re.union (str.to_re "100") ((_ re.loop 1 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
