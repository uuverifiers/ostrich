;test regex (.{70}[^ \n]*) ([^ ])
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 70 70) (re.diff re.allchar (str.to_re "\n"))) (re.* (re.inter (re.diff re.allchar (str.to_re " ")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.++ (str.to_re " ") (re.diff re.allchar (str.to_re " "))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)