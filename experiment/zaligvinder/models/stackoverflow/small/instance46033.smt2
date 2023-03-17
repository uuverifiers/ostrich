;test regex [2-2][1-1][4-4][0-6][0-9]{6}
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "2" "2") (re.++ (re.range "1" "1") (re.++ (re.range "4" "4") (re.++ (re.range "0" "6") ((_ re.loop 6 6) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)