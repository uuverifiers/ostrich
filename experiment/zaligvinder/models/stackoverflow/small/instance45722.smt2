;test regex \((([a-zA-Z]{5,10} .*?)|(\d{4}))\)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "(") (re.++ (re.union (re.++ ((_ re.loop 5 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.* (re.diff re.allchar (str.to_re "\n"))))) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re ")")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)