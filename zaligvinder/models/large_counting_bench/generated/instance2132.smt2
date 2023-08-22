;test regex $regex = '|^[a-zA-Z0-9]{1,100}+\.+(jpe?g)$|';
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{27}")))))))))) (re.++ (re.++ (str.to_re "") (re.++ (re.+ ((_ re.loop 1 100) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.++ (re.+ (str.to_re ".")) (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "e")) (str.to_re "g"))))))) (str.to_re ""))) (re.++ (str.to_re "\u{27}") (str.to_re ";")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)