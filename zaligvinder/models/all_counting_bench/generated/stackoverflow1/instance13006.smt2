;test regex ^(\d+-){3}[.]{3}-\d+(&Ns=\d+)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.++ (re.+ (re.range "0" "9")) (str.to_re "-"))) (re.++ ((_ re.loop 3 3) (str.to_re ".")) (re.++ (str.to_re "-") (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re "&") (re.++ (str.to_re "N") (re.++ (str.to_re "s") (re.++ (str.to_re "=") (re.+ (re.range "0" "9")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)