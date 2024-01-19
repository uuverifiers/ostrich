;test regex ^[a-z]{4,10}\.[a-z]{4,10}[@]abc\.(com|ca|org)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 10) (re.range "a" "z")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 4 10) (re.range "a" "z")) (re.++ (str.to_re "@") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))) (re.++ (str.to_re "c") (str.to_re "a"))) (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "g"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)