;test regex ((1010xxx)?(\d{11}|\d{10}|\d{7})+)
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "1010") (re.++ (str.to_re "x") (re.++ (str.to_re "x") (str.to_re "x"))))) (re.+ (re.union (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) ((_ re.loop 7 7) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)