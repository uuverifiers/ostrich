;test regex ^[-+].{79}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (str.to_re "-") (str.to_re "+")) ((_ re.loop 79 79) (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)