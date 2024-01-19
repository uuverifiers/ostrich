;test regex PINCODE = "^([0-9]{6})?$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "P") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}"))))))))))) (re.++ (str.to_re "") (re.opt ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)