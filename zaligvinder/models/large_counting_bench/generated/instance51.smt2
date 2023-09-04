;test regex (.|\n|\r\n){10,100}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 10 100) (re.union (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}")) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)