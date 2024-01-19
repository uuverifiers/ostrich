;test regex ^[A|a|B|b|AB|ab|O|o]{1,2}[+-]{1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 2) (re.union (str.to_re "A") (re.union (str.to_re "|") (re.union (str.to_re "a") (re.union (str.to_re "|") (re.union (str.to_re "B") (re.union (str.to_re "|") (re.union (str.to_re "b") (re.union (str.to_re "|") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "|") (re.union (str.to_re "a") (re.union (str.to_re "b") (re.union (str.to_re "|") (re.union (str.to_re "O") (re.union (str.to_re "|") (str.to_re "o")))))))))))))))))) ((_ re.loop 1 1) (re.union (str.to_re "+") (str.to_re "-"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)