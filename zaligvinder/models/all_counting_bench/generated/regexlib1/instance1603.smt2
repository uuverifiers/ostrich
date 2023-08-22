;test regex ^[A-Z&#196;&#214;&#220;]{1,3}\-[ ]{0,1}[A-Z]{0,2}[0-9]{1,4}[H]{0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1 3) (re.union (re.range "A" "Z") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "196") (re.union (str.to_re ";") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "214") (re.union (str.to_re ";") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "220") (str.to_re ";")))))))))))))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 0 1) (str.to_re " ")) (re.++ ((_ re.loop 0 2) (re.range "A" "Z")) (re.++ ((_ re.loop 1 4) (re.range "0" "9")) ((_ re.loop 0 1) (str.to_re "H"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)