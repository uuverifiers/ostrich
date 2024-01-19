;test regex [A-Za-z_.0-9-]+@{1}[a-z]+([.]{1}[a-z]{2,4})+
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "_") (re.union (str.to_re ".") (re.union (re.range "0" "9") (str.to_re "-"))))))) (re.++ ((_ re.loop 1 1) (str.to_re "@")) (re.++ (re.+ (re.range "a" "z")) (re.+ (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 4) (re.range "a" "z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)