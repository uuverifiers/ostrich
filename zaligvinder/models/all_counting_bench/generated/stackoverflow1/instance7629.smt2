;test regex ^\({0,1}[2-9]{1}[0-9]{2}\){1} {1}[2-9]{1}[0-9]{2}-{0,1}[0-9]{0,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 1) (str.to_re "(")) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re ")")) (re.++ ((_ re.loop 1 1) (str.to_re " ")) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (str.to_re "-")) ((_ re.loop 0 4) (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)