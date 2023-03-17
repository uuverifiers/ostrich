;test regex ^(AB)_(INV)_[0-4]{1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "A") (str.to_re "B")) (re.++ (str.to_re "_") (re.++ (re.++ (str.to_re "I") (re.++ (str.to_re "N") (str.to_re "V"))) (re.++ (str.to_re "_") ((_ re.loop 1 1) (re.range "0" "4")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)