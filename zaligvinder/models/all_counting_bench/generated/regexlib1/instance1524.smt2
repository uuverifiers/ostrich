;test regex ((978[\-- ])?[0-9][0-9\-- ]{10}[\-- ][0-9xX])|((978)?[0-9]{9}[0-9Xx])
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re "978") (re.range "-" " "))) (re.++ (re.range "0" "9") (re.++ ((_ re.loop 10 10) (re.union (re.range "0" "9") (re.range "-" " "))) (re.++ (re.range "-" " ") (re.union (re.range "0" "9") (re.union (str.to_re "x") (str.to_re "X"))))))) (re.++ (re.opt (str.to_re "978")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (re.union (str.to_re "X") (str.to_re "x"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)