;test regex (#([0-9a-f]){6}\s[0-9a-f]{2})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "#") (re.++ ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)