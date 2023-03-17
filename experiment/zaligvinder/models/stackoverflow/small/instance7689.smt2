;test regex "FROM:[a-z1-9A-Z ]+[<]{1}[a-z1-9]+@{1}[a-z1-9]+[.]{1}[a-z]{3}[>]{1}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "F") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ (str.to_re ":") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "1" "9") (re.union (re.range "A" "Z") (str.to_re " "))))) (re.++ ((_ re.loop 1 1) (str.to_re "<")) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "@")) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re ".")) (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ ((_ re.loop 1 1) (str.to_re ">")) (str.to_re "\u{22}")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)