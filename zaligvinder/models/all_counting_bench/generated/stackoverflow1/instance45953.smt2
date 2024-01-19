;test regex 20[0-9]{2}-[01][0-9]-[0-3][0-9]([A-Z][A-WYZ]|[A-WYZ][A-Z])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "20") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (str.to_re "01") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "3") (re.++ (re.range "0" "9") (re.union (re.++ (re.range "A" "Z") (re.union (re.range "A" "W") (re.union (str.to_re "Y") (str.to_re "Z")))) (re.++ (re.union (re.range "A" "W") (re.union (str.to_re "Y") (str.to_re "Z"))) (re.range "A" "Z")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)