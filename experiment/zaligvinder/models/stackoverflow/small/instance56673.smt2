;test regex \(([0-9]{4})\) # year
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "(") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re ")") (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re " ") (re.++ (str.to_re "y") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (str.to_re "r"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)