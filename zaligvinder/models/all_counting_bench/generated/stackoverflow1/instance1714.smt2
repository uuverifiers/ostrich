;test regex ([ ^13])([A-Z]{2}[0-9]{1,}[A-Z]{1,}[0-9]{1,})([ ^13])
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (re.union (str.to_re "^") (str.to_re "13"))) (re.++ (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "A" "Z"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))))) (re.union (str.to_re " ") (re.union (str.to_re "^") (str.to_re "13")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)