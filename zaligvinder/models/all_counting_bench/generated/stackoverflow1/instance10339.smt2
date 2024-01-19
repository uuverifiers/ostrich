;test regex L"(^.*\\D)?\\d{1,8}.tiff$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "L") (re.++ (str.to_re "\u{22}") (re.++ (re.opt (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\\") (str.to_re "D"))))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 8) (str.to_re "d")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "f") (str.to_re "f")))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)