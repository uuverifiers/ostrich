;test regex InvoiceItemID":"(\d{6})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re "n") (re.++ (str.to_re "v") (re.++ (str.to_re "o") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "I") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re ":") (re.++ (str.to_re "\u{22}") ((_ re.loop 6 6) (re.range "0" "9"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)