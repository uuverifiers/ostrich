;test regex \d{2}|DQ|Q
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "D") (str.to_re "Q"))) (str.to_re "Q"))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)