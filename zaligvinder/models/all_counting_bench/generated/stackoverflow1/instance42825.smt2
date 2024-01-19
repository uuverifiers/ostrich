;test regex (v[0-9.]{0,}).([A-Za-z]{0,}).([0-9]).zip
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "v") (re.++ (re.* (re.union (re.range "0" "9") (str.to_re "."))) ((_ re.loop 0 0) (re.union (re.range "0" "9") (str.to_re "."))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 0 0) (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.range "0" "9") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "z") (re.++ (str.to_re "i") (str.to_re "p")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)