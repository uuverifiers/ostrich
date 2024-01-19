;test regex ^\-?(([0-9]\d?|0\d{1,2})((\.)\d{0,2})?|99999999999.999((\.)0{1,2})?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.union (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 1 2) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "99999999999") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "999") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)