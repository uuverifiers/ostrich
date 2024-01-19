;test regex =isvalid_function(A2,"^\d{3,4}\.\d{2}\.\d{2}$")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "=") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "_") (re.++ (str.to_re "f") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (re.++ (re.++ (re.++ (str.to_re "A") (str.to_re "2")) (re.++ (str.to_re ",") (str.to_re "\u{22}"))) (re.++ (str.to_re "") (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)