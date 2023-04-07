;test regex TEST_(\d{4}).xml.gz
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "x") (re.++ (str.to_re "m") (re.++ (str.to_re "l") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "g") (str.to_re "z")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)