;test regex [\d ]{10,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re " "))) ((_ re.loop 10 10) (re.union (re.range "0" "9") (str.to_re " "))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)