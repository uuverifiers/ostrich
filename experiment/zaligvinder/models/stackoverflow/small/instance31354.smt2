;test regex "^(\\d{2})(?:OCT|NOV)(\\d{2}) (\\d{1,2}):(\\d{2})$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (re.union (re.++ (str.to_re "O") (re.++ (str.to_re "C") (str.to_re "T"))) (re.++ (str.to_re "N") (re.++ (str.to_re "O") (str.to_re "V")))) (re.++ (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d"))) (re.++ (str.to_re ":") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)