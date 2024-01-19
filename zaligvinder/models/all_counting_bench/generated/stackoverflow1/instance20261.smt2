;test regex ^(?:.*://)?(?:[wW]{3}\.)?([^:/])*/.*job.*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ":") (re.++ (str.to_re "/") (str.to_re "/"))))) (re.++ (re.opt (re.++ ((_ re.loop 3 3) (re.union (str.to_re "w") (str.to_re "W"))) (str.to_re "."))) (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re ":")) (re.diff re.allchar (str.to_re "/")))) (re.++ (str.to_re "/") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "j") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)