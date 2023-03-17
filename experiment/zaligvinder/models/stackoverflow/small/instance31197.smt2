;test regex FILED.*([0-9]{4})([0-9]{2})([0-9]{2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "F") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "D") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)