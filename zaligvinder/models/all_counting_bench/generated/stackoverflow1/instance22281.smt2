;test regex ([A]{2,}|[B]{2,}|[C]{2,}|[D]{2,}|[E]{2,}|...)*
(declare-const X String)
(assert (str.in_re X (re.* (re.union (re.union (re.union (re.union (re.union (re.++ (re.* (str.to_re "A")) ((_ re.loop 2 2) (str.to_re "A"))) (re.++ (re.* (str.to_re "B")) ((_ re.loop 2 2) (str.to_re "B")))) (re.++ (re.* (str.to_re "C")) ((_ re.loop 2 2) (str.to_re "C")))) (re.++ (re.* (str.to_re "D")) ((_ re.loop 2 2) (str.to_re "D")))) (re.++ (re.* (str.to_re "E")) ((_ re.loop 2 2) (str.to_re "E")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)