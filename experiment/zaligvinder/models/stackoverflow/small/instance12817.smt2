;test regex if (ereg("^[^@]+@([a-z0-9\-]+\.)+[a-z]{2,4}$", $email))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (str.to_re "@"))) (re.++ (str.to_re "@") (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (str.to_re "."))) ((_ re.loop 2 4) (re.range "a" "z"))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (re.++ (str.to_re ",") (str.to_re " "))) (re.++ (str.to_re "") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)