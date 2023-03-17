;test regex [25][1-7][0-9]{14}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "25") (re.++ (re.range "1" "7") ((_ re.loop 14 14) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)