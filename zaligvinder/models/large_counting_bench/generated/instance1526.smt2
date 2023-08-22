;test regex \replace{101}\and{3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ ((_ re.loop 101 101) (str.to_re "e")) (re.++ (str.to_re "a") (re.++ (str.to_re "n") ((_ re.loop 3 3) (str.to_re "d")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)