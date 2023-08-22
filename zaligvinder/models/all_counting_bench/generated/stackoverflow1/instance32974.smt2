;test regex ^0 2 \* \* [0-6]((,[0-6]){0,6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ (str.to_re " ") (re.++ (str.to_re "2") (re.++ (str.to_re " ") (re.++ (str.to_re "*") (re.++ (str.to_re " ") (re.++ (str.to_re "*") (re.++ (str.to_re " ") (re.++ (re.range "0" "6") ((_ re.loop 0 6) (re.++ (str.to_re ",") (re.range "0" "6"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)