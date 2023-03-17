;test regex '^5X[0-9]{1,}.?[0-9]{1,}(/115)|5X115'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "") (re.++ (str.to_re "5") (re.++ (str.to_re "X") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "/") (str.to_re "115"))))))))) (re.++ (str.to_re "5") (re.++ (str.to_re "X") (re.++ (str.to_re "115") (str.to_re "\u{27}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)