;test regex [A-Z]{4,5}_[IO]_[0-9]{4}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 5) (re.range "A" "Z")) (re.++ (str.to_re "_") (re.++ (re.union (str.to_re "I") (str.to_re "O")) (re.++ (str.to_re "_") ((_ re.loop 4 4) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)