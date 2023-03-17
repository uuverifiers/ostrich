;test regex r'href=WAC/[d]{4}/[d][d]/[d][d]'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re "=") (re.++ (str.to_re "W") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "d") (re.++ (str.to_re "/") (re.++ (str.to_re "d") (re.++ (str.to_re "d") (str.to_re "\u{27}")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)