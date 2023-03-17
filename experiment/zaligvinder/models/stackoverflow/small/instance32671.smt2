;test regex if (cardNum.matches("^4\\d{16,19}"));
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "d") (re.++ (str.to_re "N") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (str.to_re "4") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 16 19) (str.to_re "d")) (str.to_re "\u{22}"))))))))))))))))))))) (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)