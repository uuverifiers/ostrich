;test regex string pattern = @"^(0[xX][0-9A-Fa-f]{1,2})(;0[xX][0-9A-Fa-f]{1,2})*$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (str.to_re "\u{22}"))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "0") (re.++ (re.union (str.to_re "x") (str.to_re "X")) ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f")))))) (re.* (re.++ (str.to_re ";") (re.++ (str.to_re "0") (re.++ (re.union (str.to_re "x") (str.to_re "X")) ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)