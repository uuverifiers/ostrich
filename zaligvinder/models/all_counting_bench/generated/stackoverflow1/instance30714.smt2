;test regex (\r\n|\n|\r)$1{2,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "\u{0a}")) (str.to_re "\u{0d}")) (re.++ (str.to_re "") (re.++ (re.* (str.to_re "1")) ((_ re.loop 2 2) (str.to_re "1")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)