;test regex "^(.{20})(.{10})(.{2})(.{2})(.{2})$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 10 10) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)