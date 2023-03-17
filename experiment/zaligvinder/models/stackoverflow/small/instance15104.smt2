;test regex ^([\d\w\-]+)(|_[a-z]?[0-9]{3,4})\.(jpg|jpeg|png)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-")))) (re.++ (re.union (str.to_re "") (re.++ (str.to_re "") (re.++ (str.to_re "_") (re.++ (re.opt (re.range "a" "z")) ((_ re.loop 3 4) (re.range "0" "9")))))) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))) (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (str.to_re "g"))))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)