;test regex [^start](.*)(end){1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.inter (re.diff re.allchar (str.to_re "s")) (re.inter (re.diff re.allchar (str.to_re "t")) (re.inter (re.diff re.allchar (str.to_re "a")) (re.inter (re.diff re.allchar (str.to_re "r")) (re.diff re.allchar (str.to_re "t")))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 1 1) (re.++ (str.to_re "e") (re.++ (str.to_re "n") (str.to_re "d"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)