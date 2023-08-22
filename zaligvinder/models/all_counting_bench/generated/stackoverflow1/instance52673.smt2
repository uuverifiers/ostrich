;test regex ((10|[0-9])\;(1000|[\d]{1,3})\;[a-zA-Z0-9\s]*)(\|(10|[0-9])\;(1000|[\d]{1,3})\;[a-zA-Z0-9\s]*)*
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "10") (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ (re.union (str.to_re "1000") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re ";") (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))) (re.* (re.++ (str.to_re "|") (re.++ (re.union (str.to_re "10") (re.range "0" "9")) (re.++ (str.to_re ";") (re.++ (re.union (str.to_re "1000") ((_ re.loop 1 3) (re.range "0" "9"))) (re.++ (str.to_re ";") (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)