;test regex \'.$delim.'\'.$delim.'[a-zA-Z0-9]{4,8}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "\u{27}") (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\u{27}") (re.diff re.allchar (str.to_re "\n")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\u{27}") ((_ re.loop 4 8) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)