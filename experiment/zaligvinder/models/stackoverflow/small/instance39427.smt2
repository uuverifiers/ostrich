;test regex ^I_LOVE_TO_CODE(_\d{8}\.txt|)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "I") (re.++ (str.to_re "_") (re.++ (str.to_re "L") (re.++ (str.to_re "O") (re.++ (str.to_re "V") (re.++ (str.to_re "E") (re.++ (str.to_re "_") (re.++ (str.to_re "T") (re.++ (str.to_re "O") (re.++ (str.to_re "_") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.union (re.++ (str.to_re "") (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))) (str.to_re ""))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)