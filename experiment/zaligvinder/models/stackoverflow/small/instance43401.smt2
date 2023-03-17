;test regex [^a-zA-Z]{1}[a-zA-Z]{1}\d{6}[^a-zA-Z\d]{1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.diff re.allchar (re.range "A" "Z")))) (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)