;test regex foo.match(/^[0-9a-z]{3,10}$/i) && foo.match(/[a-z]/i);
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") ((_ re.loop 3 10) (re.union (re.range "0" "9") (re.range "a" "z"))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (str.to_re "i")))) (re.++ (str.to_re " ") (re.++ (str.to_re "&") (re.++ (str.to_re "&") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (str.to_re "/") (re.++ (re.range "a" "z") (re.++ (str.to_re "/") (str.to_re "i")))) (str.to_re ";")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)