;test regex .Text = "[^.]*\([A-Z]{2,}\)[^.]*\."
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "T") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "."))) (re.++ (str.to_re "(") (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ (str.to_re ")") (re.++ (re.* (re.diff re.allchar (str.to_re "."))) (re.++ (str.to_re ".") (str.to_re "\u{22}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)