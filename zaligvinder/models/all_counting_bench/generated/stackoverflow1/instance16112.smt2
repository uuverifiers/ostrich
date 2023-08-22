;test regex ^(?:[1-9]\d{0,4}|1[0-6]\d{4}|170000)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 4) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "6") ((_ re.loop 4 4) (re.range "0" "9"))))) (str.to_re "170000"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)