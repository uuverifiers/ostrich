;test regex ^.{11,}[a-z].*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 11 11) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.range "a" "z") (re.* (re.diff re.allchar (str.to_re "\n")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)