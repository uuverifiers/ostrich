;test regex ^(\d{1,2})\/(\d{1,2})\/(\d{2}{4})$ // doesn't works, does nothing
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "/") ((_ re.loop 4 4) ((_ re.loop 2 2) (re.range "0" "9")))))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "n") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "k") (str.to_re "s"))))))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "n") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "g")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)