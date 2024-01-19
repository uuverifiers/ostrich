;test regex \d{5,12}|\d{1,10}\.\d{1,10}\.\d{1,10}|\d{1,10}\.\d{1,10}
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 5 12) (re.range "0" "9")) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9"))))))) (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (re.++ (str.to_re ".") ((_ re.loop 1 10) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)