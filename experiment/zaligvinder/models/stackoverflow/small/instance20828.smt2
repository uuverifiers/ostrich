;test regex ^((?:.*?p){3}.*?)(p)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 3 3) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "p"))) (re.* (re.diff re.allchar (str.to_re "\n")))) (str.to_re "p")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)