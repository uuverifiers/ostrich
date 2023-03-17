;test regex Regex.Match(alfaNumericWord, @"(?:No|Num)\d{1,3}");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "f") (re.++ (str.to_re "a") (re.++ (str.to_re "N") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "W") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "d"))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.++ (str.to_re "N") (str.to_re "o")) (re.++ (str.to_re "N") (re.++ (str.to_re "u") (str.to_re "m")))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{22}")))))))) (str.to_re ";")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)