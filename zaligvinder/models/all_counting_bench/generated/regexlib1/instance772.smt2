;test regex ^[+]\d{1,2}\(\d{2,3}\)\d{6,8}(\#\d{1,10})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "+") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "(") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re ")") (re.++ ((_ re.loop 6 8) (re.range "0" "9")) (re.opt (re.++ (str.to_re "#") ((_ re.loop 1 10) (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)