;test regex ([0-9]{1,3}\.|\*\.){3}([0-9]{1,3}|\*){1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.++ (str.to_re "*") (str.to_re ".")))) ((_ re.loop 1 1) (re.union ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "*"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)