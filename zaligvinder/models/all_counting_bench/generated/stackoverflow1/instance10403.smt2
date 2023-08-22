;test regex ^[A-Z][a-z]+-[A-Z][a-z]+(-[A-Z][a-z]+)?\.[a-z0-9]{3,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") (re.++ (re.+ (re.range "a" "z")) (re.++ (re.opt (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z"))))) (re.++ (str.to_re ".") ((_ re.loop 3 4) (re.union (re.range "a" "z") (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)