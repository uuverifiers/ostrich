;test regex MOR(\d{3})(\d{3})(\d{3})(\d{3})|VUF(\d{5})(\d{3})(\d{2})(\d{2})|MF(\d{6})(\d{6})(\d{2})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")))))))) (re.++ (str.to_re "V") (re.++ (str.to_re "U") (re.++ (str.to_re "F") (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))))))) (re.++ (str.to_re "M") (re.++ (str.to_re "F") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)