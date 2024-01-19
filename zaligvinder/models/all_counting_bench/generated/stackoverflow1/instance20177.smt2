;test regex /[0-9]{2}\/[0-9]{2}/ 21:41 CC
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "21") (re.++ (str.to_re ":") (re.++ (str.to_re "41") (re.++ (str.to_re " ") (re.++ (str.to_re "C") (str.to_re "C"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)