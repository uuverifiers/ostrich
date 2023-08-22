;test regex (\d{11})\n  and   $1, - to replace
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ ((_ re.loop 11 11) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (str.to_re " ")))))))))) (re.++ (str.to_re "") (str.to_re "1"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (str.to_re "e")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)