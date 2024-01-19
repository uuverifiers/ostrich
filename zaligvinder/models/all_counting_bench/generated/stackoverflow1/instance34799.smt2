;test regex ^Article_[A-Z]{3}_Scout_(?:0[1-9]|[1-2][0-9]|3[01])-(?:0[1-9]|1[012])-(?:[1-9][0-9]|0[1-9])\.pptx
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ (str.to_re "S") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "p") (re.++ (str.to_re "t") (str.to_re "x")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)