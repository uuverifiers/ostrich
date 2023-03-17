;test regex \w{15}\u{01}\d{12}\u{01}\d{2}.{6}(13[0-5]\d|1400)[0-5]\d801.*
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "\u{01}") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re "\u{01}") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (re.++ (str.to_re "13") (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "1400")) (re.++ (re.range "0" "5") (re.++ (re.range "0" "9") (re.++ (str.to_re "801") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)