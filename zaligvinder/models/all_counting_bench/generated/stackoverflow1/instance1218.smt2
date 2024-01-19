;test regex "^blocka#(?:[0-9]|[1-9][0-9]|[1-3][0-9]{2})#[4-9][0-9]{2}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "k") (re.++ (str.to_re "a") (re.++ (str.to_re "#") (re.++ (re.union (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "#") (re.++ (re.range "4" "9") ((_ re.loop 2 2) (re.range "0" "9")))))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)