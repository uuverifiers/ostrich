;test regex ^(\d{3}.\d{2})(.ABC|.PQR |.XYZ)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.union (re.union (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "A") (re.++ (str.to_re "B") (str.to_re "C")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "P") (re.++ (str.to_re "Q") (re.++ (str.to_re "R") (str.to_re " ")))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "X") (re.++ (str.to_re "Y") (str.to_re "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)