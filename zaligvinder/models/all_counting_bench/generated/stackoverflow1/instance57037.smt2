;test regex ^(AL-DN-)?DI\d{7}(-\d{4}-\d{2}-\d{2}_\d{4})?\.pdf$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "-") (re.++ (str.to_re "D") (re.++ (str.to_re "N") (str.to_re "-"))))))) (re.++ (str.to_re "D") (re.++ (str.to_re "I") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "_") ((_ re.loop 4 4) (re.range "0" "9")))))))))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)