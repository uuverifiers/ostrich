(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z0-9<]{9}[0-9]{1}[A-Z]{3}[0-9]{7}[A-Z]{1}[0-9]{7}[A-Z0-9<]{14}[0-9]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 9 9) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "<"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 14 14) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "<"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[1-9][0-9]{0,6}(|.[0-9]{1,2}|,[0-9]{1,2})?
(assert (not (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 6) (re.range "0" "9")) (re.opt (re.union (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; ^([0-1])*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "1")) (str.to_re "\u{0a}")))))
(check-sat)
