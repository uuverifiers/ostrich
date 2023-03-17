;test regex var regex = "^(\\+[0-9]+ )[1-9]{2,} [0-9]{2,}(\\-[0-9]+|)$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}"))))))))))))) (re.++ (str.to_re "") (re.++ (re.++ (re.+ (str.to_re "\\")) (re.++ (re.+ (re.range "0" "9")) (str.to_re " "))) (re.++ (re.++ (re.* (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9"))) (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.union (re.++ (str.to_re "") (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.+ (re.range "0" "9"))))) (str.to_re "")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)