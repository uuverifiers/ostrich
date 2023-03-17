;test regex SELECT '22222' SIMILAR TO '[1-3]{5}';
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "22222") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ (str.to_re "M") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "T") (re.++ (str.to_re "O") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 5 5) (re.range "1" "3")) (re.++ (str.to_re "\u{27}") (str.to_re ";"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)