;test regex ^([0-9a-f]{32}|[0-9a-f]{64})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) ((_ re.loop 64 64) (re.union (re.range "0" "9") (re.range "a" "f"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)