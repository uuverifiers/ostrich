;test regex (.?[a]{1,}.?)|(.?[b]{1,}.?)|(.?[t]{1,}.?)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (str.to_re "a")) ((_ re.loop 1 1) (str.to_re "a"))) (re.opt (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (str.to_re "b")) ((_ re.loop 1 1) (str.to_re "b"))) (re.opt (re.diff re.allchar (str.to_re "\n")))))) (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.* (str.to_re "t")) ((_ re.loop 1 1) (str.to_re "t"))) (re.opt (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)