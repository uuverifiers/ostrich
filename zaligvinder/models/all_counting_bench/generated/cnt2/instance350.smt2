;test regex ^([0-9a-f]{32,80})_[a-z]{2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 32 80) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "_") ((_ re.loop 2 2) (re.range "a" "z"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)