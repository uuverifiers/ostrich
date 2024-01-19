;test regex abc\d+_def(\d{2})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "f") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)