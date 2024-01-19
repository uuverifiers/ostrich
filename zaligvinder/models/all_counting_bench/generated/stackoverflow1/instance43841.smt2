;test regex html.replace(/E[0-9]{3,4}/g, "<strong>$&</strong>");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (re.++ (str.to_re "l") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (re.++ (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "E") (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (re.++ (str.to_re "/") (str.to_re "g"))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "<") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (str.to_re ">")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "&") (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re ">") (str.to_re "\u{22}"))))))))))))) (str.to_re ";"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)