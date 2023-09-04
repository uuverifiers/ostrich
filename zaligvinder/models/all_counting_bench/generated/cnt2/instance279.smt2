;test regex ^(<(?:\\\\|.|[^<>]){0,1024}>)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "<") (re.++ ((_ re.loop 0 1024) (re.union (re.union (re.++ (str.to_re "\\") (str.to_re "\\")) (re.diff re.allchar (str.to_re "\n"))) (re.inter (re.diff re.allchar (str.to_re "<")) (re.diff re.allchar (str.to_re ">"))))) (str.to_re ">"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)