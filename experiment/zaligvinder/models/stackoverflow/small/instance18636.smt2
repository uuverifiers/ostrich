;test regex ^[a-zA-Z]+\d{3}@yahoo\.com$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "@") (re.++ (str.to_re "y") (re.++ (str.to_re "a") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)