;test regex ^[A-Z][a-z]{2}(?:[1-9][0-9]?|1[0-4][0-9]|150):(?:[1-9][0-9]?|1[0-6][0-9]|17[0-6])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (re.union (re.union (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "4") (re.range "0" "9")))) (str.to_re "150")) (re.++ (str.to_re ":") (re.union (re.union (re.++ (re.range "1" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "6") (re.range "0" "9")))) (re.++ (str.to_re "17") (re.range "0" "6")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)