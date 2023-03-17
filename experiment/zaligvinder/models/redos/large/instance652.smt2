;test regex ([0-9a-f]{16})[0-9a-f]{48}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.range "a" "f"))) ((_ re.loop 48 48) (re.union (re.range "0" "9") (re.range "a" "f"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)