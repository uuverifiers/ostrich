;test regex ^(-?(?:1[0-7]|[1-9])?\d(?:\.\d{1,8})?|180(?:\.0{1,8})?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (re.union (re.++ (str.to_re "1") (re.range "0" "7")) (re.range "1" "9"))) (re.++ (re.range "0" "9") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 8) (re.range "0" "9"))))))) (re.++ (str.to_re "180") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 8) (str.to_re "0"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)