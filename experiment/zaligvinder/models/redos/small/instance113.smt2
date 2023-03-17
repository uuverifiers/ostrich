;test regex ^(6011|65\d{2}|64[4-9]\d)\d{12}|(62\d{14})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.union (re.union (str.to_re "6011") (re.++ (str.to_re "65") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "64") (re.++ (re.range "4" "9") (re.range "0" "9")))) ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (re.++ (str.to_re "62") ((_ re.loop 14 14) (re.range "0" "9"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)