;test regex (GET|POST|SEGMENT)\[(.*?)\](\^){0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "G") (re.++ (str.to_re "E") (str.to_re "T"))) (re.++ (str.to_re "P") (re.++ (str.to_re "O") (re.++ (str.to_re "S") (str.to_re "T"))))) (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (str.to_re "T")))))))) (re.++ (str.to_re "[") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "]") ((_ re.loop 0 1) (str.to_re "^"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)