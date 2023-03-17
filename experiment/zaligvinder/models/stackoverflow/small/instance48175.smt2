;test regex if(Regex.IsMatch(STRINGTOCHECK, @"[a-zA-Z0-9]{16}$"))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "i") (re.++ (str.to_re "f") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "I") (re.++ (str.to_re "s") (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "G") (re.++ (str.to_re "T") (re.++ (str.to_re "O") (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (str.to_re "K"))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (re.++ (str.to_re "\u{22}") ((_ re.loop 16 16) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)