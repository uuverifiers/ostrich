;test regex ^[ 0-9A-Z] [ 0-9]{4}[0-9][/ ][ 0-9A-z]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re " ") (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.union (str.to_re " ") (re.range "0" "9"))) (re.++ (re.range "0" "9") (re.++ (re.union (str.to_re "/") (str.to_re " ")) (re.union (str.to_re " ") (re.union (re.range "0" "9") (re.range "A" "z"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)