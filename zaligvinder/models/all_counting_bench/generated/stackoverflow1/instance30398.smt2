;test regex \A(55[0-9])|(70[0-9])|(77[0-9])\d{6}\z
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "55") (re.range "0" "9"))) (re.++ (str.to_re "70") (re.range "0" "9"))) (re.++ (re.++ (str.to_re "77") (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)