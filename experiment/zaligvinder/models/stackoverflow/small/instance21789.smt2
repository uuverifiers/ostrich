;test regex ((foo|bar|baz).*?){2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) (re.++ (re.union (re.union (re.++ (str.to_re "f") (re.++ (str.to_re "o") (str.to_re "o"))) (re.++ (str.to_re "b") (re.++ (str.to_re "a") (str.to_re "r")))) (re.++ (str.to_re "b") (re.++ (str.to_re "a") (str.to_re "z")))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)