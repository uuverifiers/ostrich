;test regex grep( "de[a-zA-Z0-9]{3}", df$code)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "\u{22}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "d") (str.to_re "f"))))) (re.++ (str.to_re "") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "d") (str.to_re "e"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)