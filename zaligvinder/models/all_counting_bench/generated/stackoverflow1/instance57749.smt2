;test regex a.{2}b.{2}c.{2}d
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "b") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "c") (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "d")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)