;test regex \A(.*\r?\n){3}|(\r?\n.*){3}\z
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "A") ((_ re.loop 3 3) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))) (re.++ ((_ re.loop 3 3) (re.++ (re.opt (str.to_re "\u{0d}")) (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\n")))))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)