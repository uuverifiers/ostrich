;test regex ^reg_no [0-9]{2}[FS]-(?:[BM]S)(?:CS|SE)-[0-9]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "_") (re.++ (str.to_re "n") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re "F") (str.to_re "S")) (re.++ (str.to_re "-") (re.++ (re.++ (re.union (str.to_re "B") (str.to_re "M")) (str.to_re "S")) (re.++ (re.union (re.++ (str.to_re "C") (str.to_re "S")) (re.++ (str.to_re "S") (str.to_re "E"))) (re.++ (str.to_re "-") (re.range "0" "9"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)