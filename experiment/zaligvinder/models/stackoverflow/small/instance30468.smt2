;test regex F\_[ES]{1}\_([\w\d]+)\_([\w\d]+)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "F") (re.++ (str.to_re "_") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "E") (str.to_re "S"))) (re.++ (str.to_re "_") (re.++ (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.range "0" "9"))) (re.++ (str.to_re "_") (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)