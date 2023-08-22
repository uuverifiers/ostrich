;test regex ^AB([0-9]{0,6}|[0-9]{6}[A-Z][0-9]{0,2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.union ((_ re.loop 0 6) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (re.range "A" "Z") ((_ re.loop 0 2) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)