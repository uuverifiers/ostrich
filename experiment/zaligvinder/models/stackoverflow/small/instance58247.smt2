;test regex ^[alopinmexyz]{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 5 5) (re.union (str.to_re "a") (re.union (str.to_re "l") (re.union (str.to_re "o") (re.union (str.to_re "p") (re.union (str.to_re "i") (re.union (str.to_re "n") (re.union (str.to_re "m") (re.union (str.to_re "e") (re.union (str.to_re "x") (re.union (str.to_re "y") (str.to_re "z"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)