;test regex I have {323} dollars
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "a") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ ((_ re.loop 323 323) (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "s")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)