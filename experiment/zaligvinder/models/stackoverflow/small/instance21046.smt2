;test regex ^(?:[^cfdrp].*|.[^a].*|..[^n].*|.{4,}|.{0,2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.++ (re.inter (re.diff re.allchar (str.to_re "c")) (re.inter (re.diff re.allchar (str.to_re "f")) (re.inter (re.diff re.allchar (str.to_re "d")) (re.inter (re.diff re.allchar (str.to_re "r")) (re.diff re.allchar (str.to_re "p")))))) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "a")) (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "n")) (re.* (re.diff re.allchar (str.to_re "\n"))))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n"))))) ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)