;test regex ^([a-z]{2,3}(\.[a-zA-Z][a-zA-Z_$0-9]*)*)\.([A-Z][a-zA-Z_$0-9]*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 2 3) (re.range "a" "z")) (re.* (re.++ (str.to_re ".") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "_") (re.union (str.to_re "$") (re.range "0" "9")))))))))) (re.++ (str.to_re ".") (re.++ (re.range "A" "Z") (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "_") (re.union (str.to_re "$") (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)