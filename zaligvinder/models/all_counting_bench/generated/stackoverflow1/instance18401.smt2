;test regex (a.*){2}b.*b|(b.*){2}a.*a|(a.*b|b.*a){2}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "a") (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "b") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "b")))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "b") (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "a") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "a"))))) ((_ re.loop 2 2) (re.union (re.++ (str.to_re "a") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "b"))) (re.++ (str.to_re "b") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "a"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)