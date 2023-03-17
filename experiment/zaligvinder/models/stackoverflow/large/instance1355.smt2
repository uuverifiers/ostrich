;test regex [A-Za-z\d][-A-Za-z\d]{3,498}[A-Za-z\d]
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ ((_ re.loop 3 498) (re.union (str.to_re "-") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)