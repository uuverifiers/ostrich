;test regex [abc]{0,2}[^abc]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 2) (re.union (str.to_re "a") (re.union (str.to_re "b") (str.to_re "c")))) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "b")) (re.diff re.allchar (str.to_re "c")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)