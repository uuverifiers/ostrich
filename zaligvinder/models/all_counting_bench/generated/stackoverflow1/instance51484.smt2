;test regex ^[0-9]{2}(?:[01][0-9][0-9]|[24]00|3(?:6[6-9]|[7-9][0-9]))[0-9]{4}[xX]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.union (re.++ (str.to_re "01") (re.++ (re.range "0" "9") (re.range "0" "9"))) (re.++ (str.to_re "24") (str.to_re "00"))) (re.++ (str.to_re "3") (re.union (re.++ (str.to_re "6") (re.range "6" "9")) (re.++ (re.range "7" "9") (re.range "0" "9"))))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "x") (str.to_re "X")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)