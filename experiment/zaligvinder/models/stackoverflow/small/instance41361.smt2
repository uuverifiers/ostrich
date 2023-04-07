;test regex ^(?:(SC|NI|[0-9]{2})[0-9]{6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "S") (str.to_re "C")) (re.++ (str.to_re "N") (str.to_re "I"))) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 6 6) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)