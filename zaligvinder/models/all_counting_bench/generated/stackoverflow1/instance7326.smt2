;test regex ^[\w.]{1,25}\.(jpg|gif|png|jpeg|doc|docx|pdf|txt|rtf)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 25) (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "."))) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))) (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (str.to_re "g"))))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (str.to_re "c")))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (str.to_re "x"))))) (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))) (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t")))) (re.++ (str.to_re "r") (re.++ (str.to_re "t") (str.to_re "f"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)