;test regex CHECK (gridref::text ~ '^[A-Z]{2}[0-9]{8}$'::text);
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "K") (re.++ (str.to_re " ") (re.++ (re.++ (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "~") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t"))))))))) (str.to_re ";"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)