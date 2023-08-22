;test regex ^([^A-Za-z0-9]{2}\_|[A-Za-z0-9]{3,27})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 2 2) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.diff re.allchar (re.range "0" "9"))))) (str.to_re "_")) ((_ re.loop 3 27) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)