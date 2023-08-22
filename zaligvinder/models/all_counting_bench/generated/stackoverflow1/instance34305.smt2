;test regex ^0$|^100$|^0\\.[5-9]\\d?$|^([1-9]|\\d{2})(\\.\\d{1,2})?$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.++ (str.to_re "") (str.to_re "0")) (str.to_re "")) (re.++ (re.++ (str.to_re "") (str.to_re "100")) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.range "5" "9") (re.++ (str.to_re "\\") (re.opt (str.to_re "d")))))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))) (re.opt (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d")))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)