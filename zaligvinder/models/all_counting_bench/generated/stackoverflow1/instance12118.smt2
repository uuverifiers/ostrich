;test regex ((.*){3,}[a-z]{1,}[A-Z]{1,}[0-9]{1,})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.* (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 3 3) (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 1 1) (re.range "a" "z"))) (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "A" "Z"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)