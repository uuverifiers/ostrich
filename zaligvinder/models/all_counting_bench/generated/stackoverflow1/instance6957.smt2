;test regex 1 one more ([0-9]{1,3}) and it must end with ([0-9]{3})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re " ") (re.opt ((_ re.loop 3 3) (re.range "0" "9"))))))))))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)