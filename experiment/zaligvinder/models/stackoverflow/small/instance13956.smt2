;test regex ^((10|0)*11(01|0)*){2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 2 2) (re.++ (re.* (re.union (str.to_re "10") (str.to_re "0"))) (re.++ (str.to_re "11") (re.* (re.union (str.to_re "01") (str.to_re "0"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)