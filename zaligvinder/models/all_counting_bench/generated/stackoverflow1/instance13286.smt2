;test regex ^([A-Za-z ]*[^A-Za-z ]){0,3}[A-Za-z ]*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 3) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re " ")))) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.diff re.allchar (str.to_re " ")))))) (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re " ")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)