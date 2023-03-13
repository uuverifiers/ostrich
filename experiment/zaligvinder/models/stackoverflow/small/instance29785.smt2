;test regex ^?(([1-9]{1,3}(,\d{3})*(\.\d{2})?)|(0\.[1-9]\d)|(0\.0[1-9]))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (str.to_re "")) (re.union (re.union (re.++ ((_ re.loop 1 3) (re.range "1" "9")) (re.++ (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))) (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (re.range "1" "9") (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.++ (str.to_re ".") (re.++ (str.to_re "0") (re.range "1" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)