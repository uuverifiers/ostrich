;test regex (\x2B{1}3{1}2{1}\u{28}{1}\d{1}\u{29}{1}\d{2}\/\d{2}\.\d{2}\.\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "\u{2b}")) (re.++ ((_ re.loop 1 1) (str.to_re "3")) (re.++ ((_ re.loop 1 1) (str.to_re "2")) (re.++ ((_ re.loop 1 1) (str.to_re "\u{28}")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "\u{29}")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)