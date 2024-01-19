;test regex pattern = '^[B-Zb-z][A-Za-z]*[Aa]{2}'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))))) (re.++ (str.to_re "") (re.++ (re.union (re.range "B" "Z") (re.range "b" "z")) (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "a"))) (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)