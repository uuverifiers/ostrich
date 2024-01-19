;test regex &#(0{0,2}[1-2]\d|000\d|0{0,2}3[01]|x0{0,2}[01][0-9A-Fa-f]);
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "&") (re.++ (str.to_re "#") (re.++ (re.union (re.union (re.union (re.++ ((_ re.loop 0 2) (str.to_re "0")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.++ (str.to_re "000") (re.range "0" "9"))) (re.++ ((_ re.loop 0 2) (str.to_re "0")) (re.++ (str.to_re "3") (str.to_re "01")))) (re.++ (str.to_re "x") (re.++ ((_ re.loop 0 2) (str.to_re "0")) (re.++ (str.to_re "01") (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))))) (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)