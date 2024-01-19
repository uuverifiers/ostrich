(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d)?(\d{1})(\.{1})(\d)?(\d{1})){1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.opt (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) (re.opt (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[1-4]\d{3}\/((0?[1-6]\/((3[0-1])|([1-2][0-9])|(0?[1-9])))|((1[0-2]|(0?[7-9]))\/(30|([1-2][0-9])|(0?[1-9]))))$
(assert (not (str.in_re X (re.++ (re.range "1" "4") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "6") (str.to_re "/") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) (re.range "7" "9"))) (str.to_re "/") (re.union (str.to_re "30") (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
