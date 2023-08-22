;test regex (([0-9]{1,2}h)?[0-9]{1,2}m)?[0-9]{1,2}(\.[0-9]{1,3})?s|([0-9]{1,2}h)?[0-9]{1,2}m|[0-9]{1,2}h
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.opt (re.++ (re.opt (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "m")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (str.to_re "s")))) (re.++ (re.opt (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "m")))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "h")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)