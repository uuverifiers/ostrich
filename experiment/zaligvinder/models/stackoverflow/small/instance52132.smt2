;test regex /^[a-z\d]{4,15}$/i.test (s) && /\d[a-z]|[a-z]\d/i.test (s);
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") ((_ re.loop 4 15) (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "&") (re.++ (str.to_re "&") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (re.range "0" "9") (re.range "a" "z")))))))))))))))))) (re.++ (re.range "a" "z") (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (str.to_re ";")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)