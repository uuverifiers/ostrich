;test regex ^(.{51}).{117}(.{3})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 51 51) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 117 117) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)