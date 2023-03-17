;test regex (11  12.\r?\n){3,7}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 3 7) (re.++ (str.to_re "11") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "12") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)