;test regex ^(?:7\d{6}|777\d{6}|777\d{8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "7") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "777") ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (str.to_re "777") ((_ re.loop 8 8) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)