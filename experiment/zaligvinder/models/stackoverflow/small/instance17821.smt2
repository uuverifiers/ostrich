;test regex ^[abceghj-prstw-z][abceghj-nprstw-z]\d{6}[abcd]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (str.to_re "e") (re.union (str.to_re "g") (re.union (str.to_re "h") (re.union (re.range "j" "p") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.range "w" "z"))))))))))) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "c") (re.union (str.to_re "e") (re.union (str.to_re "g") (re.union (str.to_re "h") (re.union (re.range "j" "n") (re.union (str.to_re "p") (re.union (str.to_re "r") (re.union (str.to_re "s") (re.union (str.to_re "t") (re.range "w" "z")))))))))))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "c") (str.to_re "d")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)