;test regex (\+971|00971|05)(\d{1,12})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "+") (str.to_re "971")) (str.to_re "00971")) (str.to_re "05")) ((_ re.loop 1 12) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)