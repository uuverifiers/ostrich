;test regex ^([\pN\pL\pM]*\s){0,3}[\pN\pL\pM]*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 3) (re.++ (re.* (re.union (str.to_re "p") (re.union (str.to_re "N") (re.union (str.to_re "p") (re.union (str.to_re "L") (re.union (str.to_re "p") (str.to_re "M"))))))) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) (re.* (re.union (str.to_re "p") (re.union (str.to_re "N") (re.union (str.to_re "p") (re.union (str.to_re "L") (re.union (str.to_re "p") (str.to_re "M"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)