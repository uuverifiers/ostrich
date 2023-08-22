;test regex value="[1-9][0-9]{7}|[1-4][0-9]{8}"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.range "1" "9") ((_ re.loop 7 7) (re.range "0" "9")))))))))) (re.++ (re.range "1" "4") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)