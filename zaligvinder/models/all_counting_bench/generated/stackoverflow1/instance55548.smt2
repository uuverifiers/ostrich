;test regex gsub("^[0-9]{1,4}\\s","",df$Kunden.Nr..Kurzname)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (str.to_re "\u{22}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}")))) (re.++ (str.to_re ",") (re.++ (str.to_re "d") (str.to_re "f")))) (re.++ (str.to_re "") (re.++ (str.to_re "K") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "N") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "K") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "z") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "e")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)