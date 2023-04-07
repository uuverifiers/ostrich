;test regex (.+?(\r\n)){1000}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1000 1000) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)