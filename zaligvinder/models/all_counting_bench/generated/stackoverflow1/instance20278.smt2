;test regex ^(GIR 0AA)|((([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) [0-9][A-Z]{2})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "G") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.++ (str.to_re "A") (str.to_re "A")))))))) (re.++ (re.++ (re.union (re.++ (re.range "A" "Z") ((_ re.loop 1 2) (re.range "0" "9"))) (re.union (re.++ (re.range "A" "Z") (re.++ (re.union (re.range "A" "H") (re.range "J" "Y")) ((_ re.loop 1 2) (re.range "0" "9")))) (re.union (re.++ (re.range "A" "Z") (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.++ (re.range "A" "Z") (re.++ (re.union (re.range "A" "H") (re.range "J" "Y")) (re.++ (re.opt (re.range "0" "9")) (re.range "A" "Z"))))))) (re.++ (str.to_re " ") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)