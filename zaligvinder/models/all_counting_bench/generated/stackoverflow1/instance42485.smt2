;test regex $regex = '~^[(]?032[)-]?\d{7}$~';
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (str.to_re "~"))))))))))) (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "(")) (re.++ (str.to_re "032") (re.++ (re.opt (re.union (str.to_re ")") (str.to_re "-"))) ((_ re.loop 7 7) (re.range "0" "9"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "~") (re.++ (str.to_re "\u{27}") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)