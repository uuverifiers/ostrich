;test regex (.?(WORD)){2}((.|\n)*)BORDERWORD
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (str.to_re "D")))))) (re.++ (re.* (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}"))) (re.++ (str.to_re "B") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (str.to_re "D"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)