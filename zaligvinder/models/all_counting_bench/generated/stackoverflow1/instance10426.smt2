;test regex ^((?:Mr\.|Mrs\.|Ms\.) [^.]*[A-Z]{2,})(?:(?: of )([^.]*)){0,1}\.
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "r") (str.to_re "."))) (re.++ (str.to_re "M") (re.++ (str.to_re "r") (re.++ (str.to_re "s") (str.to_re "."))))) (re.++ (str.to_re "M") (re.++ (str.to_re "s") (str.to_re ".")))) (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "."))) (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "A" "Z")))))) (re.++ ((_ re.loop 0 1) (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "f") (str.to_re " ")))) (re.* (re.diff re.allchar (str.to_re "."))))) (str.to_re "."))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)