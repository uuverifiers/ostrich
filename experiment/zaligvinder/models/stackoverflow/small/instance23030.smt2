;test regex [vV][aAeEyY][15678]\w{2,3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "v") (str.to_re "V")) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "A") (re.union (str.to_re "e") (re.union (str.to_re "E") (re.union (str.to_re "y") (str.to_re "Y")))))) (re.++ (str.to_re "15678") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)