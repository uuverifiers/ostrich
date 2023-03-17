;test regex ^un.{2,}[aeiouAEIOU]{2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "u") (re.++ (str.to_re "n") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 2 2) (re.union (str.to_re "a") (re.union (str.to_re "e") (re.union (str.to_re "i") (re.union (str.to_re "o") (re.union (str.to_re "u") (re.union (str.to_re "A") (re.union (str.to_re "E") (re.union (str.to_re "I") (re.union (str.to_re "O") (str.to_re "U"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)