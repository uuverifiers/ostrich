;test regex ^[a-z]{2}0[01][0-9]{2,10}[0-9]{10}\.(?:jpe?g|png|gif)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "0") (re.++ (str.to_re "01") (re.++ ((_ re.loop 2 10) (re.range "0" "9")) (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (re.opt (str.to_re "e")) (str.to_re "g")))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)