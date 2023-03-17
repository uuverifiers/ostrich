;test regex r'[A-z\d,\-.\ \/\n]{1,}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (re.++ (re.* (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re ",") (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re " ") (re.union (str.to_re "/") (str.to_re "\u{0a}"))))))))) ((_ re.loop 1 1) (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re ",") (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re " ") (re.union (str.to_re "/") (str.to_re "\u{0a}")))))))))) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)