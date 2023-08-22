;test regex [Bb]lank[ \-]{0,3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "B") (str.to_re "b")) (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "k") ((_ re.loop 0 3) (re.union (str.to_re " ") (str.to_re "-"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)