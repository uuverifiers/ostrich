;test regex ^(?:(?:.*\n){2})*?((?:2[6-9]|[3-9][0-9]|100)).*\n.*Apples
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* ((_ re.loop 2 2) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}")))) (re.++ (re.union (re.union (re.++ (str.to_re "2") (re.range "6" "9")) (re.++ (re.range "3" "9") (re.range "0" "9"))) (str.to_re "100")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0a}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "A") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re "s"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)