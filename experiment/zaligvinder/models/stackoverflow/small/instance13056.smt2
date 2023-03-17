;test regex '[2-7]{1}([A-Fa-f]|[0-9]{1})'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 1 1) (re.range "2" "7")) (re.++ (re.union (re.union (re.range "A" "F") (re.range "a" "f")) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "\u{27}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)