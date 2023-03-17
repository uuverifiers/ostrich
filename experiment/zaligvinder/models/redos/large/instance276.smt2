;test regex ^(ff){16}012001040064007801010101ffff0100(ab){256}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 16 16) (re.++ (str.to_re "f") (str.to_re "f"))) (re.++ (str.to_re "012001040064007801010101") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "0100") ((_ re.loop 256 256) (re.++ (str.to_re "a") (str.to_re "b"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)