;test regex 1420[0-1][5-6][3-6][1-8]\\d{2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "1420") (re.++ (re.range "0" "1") (re.++ (re.range "5" "6") (re.++ (re.range "3" "6") (re.++ (re.range "1" "8") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)