;test regex .*((tion|exal|ta|iest|ent).*){3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 3 3) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (str.to_re "n")))) (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "a") (str.to_re "l"))))) (re.++ (str.to_re "t") (str.to_re "a"))) (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (str.to_re "t"))))) (re.++ (str.to_re "e") (re.++ (str.to_re "n") (str.to_re "t")))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)