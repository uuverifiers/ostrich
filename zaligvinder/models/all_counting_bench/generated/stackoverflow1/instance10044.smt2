;test regex "[abc]{3,}.([ab]?[^a]{4,7})"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.union (str.to_re "a") (re.union (str.to_re "b") (str.to_re "c")))) ((_ re.loop 3 3) (re.union (str.to_re "a") (re.union (str.to_re "b") (str.to_re "c"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.++ (re.opt (re.union (str.to_re "a") (str.to_re "b"))) ((_ re.loop 4 7) (re.diff re.allchar (str.to_re "a")))) (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)