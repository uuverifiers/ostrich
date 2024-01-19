;test regex ^[\u0041-\u005A\u0061-\u007A\.\' \-]{2,15}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") ((_ re.loop 2 15) (re.union (re.range "\u{0041}" "\u{005a}") (re.union (re.range "\u{0061}" "\u{007a}") (re.union (str.to_re ".") (re.union (str.to_re "\u{27}") (re.union (str.to_re " ") (str.to_re "-"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)