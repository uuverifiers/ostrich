;test regex 7\d{12}|\d\.\d+
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "7") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (re.range "0" "9") (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)