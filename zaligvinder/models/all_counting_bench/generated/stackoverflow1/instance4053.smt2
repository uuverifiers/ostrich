;test regex ^([s]{1})([0-9]{2})| ([a-rt-z]{1})([A-Za-z]{2})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (str.to_re "s")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "r") (re.range "t" "z"))) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)