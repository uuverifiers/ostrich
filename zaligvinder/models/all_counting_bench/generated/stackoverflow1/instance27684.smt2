;test regex [1-9]\d{0,2}\.(?:[1-9]|10)\.[1-9]\d{0,3}\.\d{6}
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "1" "9") (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.union (re.range "1" "9") (str.to_re "10")) (re.++ (str.to_re ".") (re.++ (re.range "1" "9") (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 6 6) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)