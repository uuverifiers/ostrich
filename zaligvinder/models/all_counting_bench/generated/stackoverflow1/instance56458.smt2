;test regex ^([0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-7][0-9]{3}|8[0-6][0-9]{2}|87[0-5][0-9]|8758)(\.\d{1,2})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.range "0" "9") (re.++ (re.range "1" "8") (re.range "0" "9"))) (re.++ (str.to_re "9") (re.range "0" "9"))) (re.++ (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "9") (re.++ (re.range "0" "8") (re.range "0" "9")))) (re.++ (str.to_re "99") (re.range "0" "9"))) (re.++ (re.range "1" "7") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "8") (re.++ (re.range "0" "6") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "87") (re.++ (re.range "0" "5") (re.range "0" "9")))) (str.to_re "8758")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)