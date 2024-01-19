;test regex and|x?or|&&|[<>!=]=|[<>&!]|\|{1,2}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "n") (str.to_re "d"))) (re.++ (re.opt (str.to_re "x")) (re.++ (str.to_re "o") (str.to_re "r")))) (re.++ (str.to_re "&") (str.to_re "&"))) (re.++ (re.union (str.to_re "<") (re.union (str.to_re ">") (re.union (str.to_re "!") (str.to_re "=")))) (str.to_re "="))) (re.union (str.to_re "<") (re.union (str.to_re ">") (re.union (str.to_re "&") (str.to_re "!"))))) ((_ re.loop 1 2) (str.to_re "|")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)