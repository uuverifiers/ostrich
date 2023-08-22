;test regex "^(((([A-Za-z0-9]+){1,63}\.)|(([A-Za-z0-9]+(\-)+[A-Za-z0-9]+){1,63}\.))+){1,255}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") ((_ re.loop 1 255) (re.+ (re.union (re.++ ((_ re.loop 1 63) (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re ".")) (re.++ ((_ re.loop 1 63) (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.+ (str.to_re "-")) (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))))) (str.to_re "."))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)