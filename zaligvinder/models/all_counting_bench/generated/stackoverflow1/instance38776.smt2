;test regex (Order_ID, "[A-Z]{1}\d{1}[A-Z]{3}")
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "O") (re.++ (str.to_re "r") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "_") (re.++ (str.to_re "I") (str.to_re "D")))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re "\u{22}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)