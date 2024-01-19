;test regex perl -00 -pe "s/\A(.*?)^(\d{5}\n)/$2$1/sm" j1.txt
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "00") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "A") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")) (str.to_re "/")))) (re.++ (str.to_re "") (str.to_re "2"))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "m") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "j") (re.++ (str.to_re "1") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)