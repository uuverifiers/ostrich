;test regex (?:^[b-df-hj-np-tv-z][aeiou]-\d{6}$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "b" "d") (re.union (re.range "f" "h") (re.union (re.range "j" "n") (re.union (re.range "p" "t") (re.range "v" "z"))))) (re.++ (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (str.to_re "u"))))) (re.++ (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)