;test regex ^([0-9A-Za-z]{0,})\.JPG$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) ((_ re.loop 0 0) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z"))))) (re.++ (str.to_re ".") (re.++ (str.to_re "J") (re.++ (str.to_re "P") (str.to_re "G")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)