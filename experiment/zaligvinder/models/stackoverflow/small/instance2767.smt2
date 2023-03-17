;test regex "\A[NS]\d{2}[WE]\d{3}\Z"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "A") (re.++ (re.union (str.to_re "N") (str.to_re "S")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "W") (str.to_re "E")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "Z") (str.to_re "\u{22}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)