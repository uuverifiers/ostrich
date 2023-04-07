;test regex ^([0-1]?[0-9]{1}/[0-3]?[0-9]{1}/20[0-9]{2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.range "0" "1")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (re.opt (re.range "0" "3")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (str.to_re "20") ((_ re.loop 2 2) (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)