;test regex (DF-(\d){7,})|NA
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "D") (re.++ (str.to_re "F") (re.++ (str.to_re "-") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9")))))) (re.++ (str.to_re "N") (str.to_re "A")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)