;test regex '[2-9]|[0-9]{2,3}'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{27}") (re.range "2" "9")) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)