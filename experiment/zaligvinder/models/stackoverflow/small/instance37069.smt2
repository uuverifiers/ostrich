;test regex Regex.IsMatch(input, @"^\d{6,8} ?[A-Za-z]{2,3}$");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "I") (re.++ (str.to_re "s") (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "p") (re.++ (str.to_re "u") (str.to_re "t"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (str.to_re "\u{22}"))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 6 8) (re.range "0" "9")) (re.++ (re.opt (str.to_re " ")) ((_ re.loop 2 3) (re.union (re.range "A" "Z") (re.range "a" "z"))))))) (re.++ (str.to_re "") (str.to_re "\u{22}"))) (str.to_re ";")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)