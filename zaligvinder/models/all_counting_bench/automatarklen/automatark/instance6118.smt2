(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (23:59:59)|([01]{1}[0-9]|2[0-3]):((00)|(15)|(30)|(45))+:(00)
(assert (not (str.in_re X (re.union (str.to_re "23:59:59") (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.+ (re.union (str.to_re "00") (str.to_re "15") (str.to_re "30") (str.to_re "45"))) (str.to_re ":00\u{0a}"))))))
; ^([1-9]|1[0-2]|0[1-9]){1}(:[0-5][0-9][aApP][mM]){1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9")))) ((_ re.loop 1 1) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")))) (str.to_re "\u{0a}"))))
; ^\$?(\d{1,3},?(\d{3},?)*\d{3}(\.\d{0,2})?|\d{1,3}(\.\d{0,2})?|\.\d{1,2}?)$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ",")) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
