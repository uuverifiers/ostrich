;test regex (\\(\d,\d\\)\s){1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (re.++ (re.range "0" "9") (re.++ (str.to_re ",") (re.++ (re.range "0" "9") (str.to_re "\\")))) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) ((_ re.loop 1 1) (re.++ (str.to_re "\\") (re.++ (re.++ (re.range "0" "9") (re.++ (str.to_re ",") (re.++ (re.range "0" "9") (str.to_re "\\")))) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)