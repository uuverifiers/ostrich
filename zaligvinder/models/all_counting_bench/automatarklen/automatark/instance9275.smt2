(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\D{0,2}[0]{0,3}[1]{0,1}\D{0,2}([2-9])(\d{2})\D{0,2}(\d{3})\D{0,2}(\d{3})\D{0,2}(\d{1})\D{0,2}$
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 0 3) (str.to_re "0")) (re.opt (str.to_re "1")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; (\d{1,3},(\d{3},)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; (^(\d{2}.\d{3}.\d{3}/\d{4}-\d{2})|(\d{14})$)|(^(\d{3}.\d{3}.\d{3}-\d{2})|(\d{11})$)
(assert (str.in_re X (re.union (re.++ (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 14 14) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
