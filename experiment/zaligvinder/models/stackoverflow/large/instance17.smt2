;test regex ^(?:[A-Z0-9]{44}|[A-Z0-9]{36}|[A-Z0-9]{30})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 44 44) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 36 36) (re.union (re.range "A" "Z") (re.range "0" "9")))) ((_ re.loop 30 30) (re.union (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)