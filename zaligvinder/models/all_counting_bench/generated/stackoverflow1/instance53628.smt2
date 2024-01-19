;test regex ^([^\W_]{2}[a-z]?)?(\d{4})[a-z]?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ ((_ re.loop 2 2) (re.inter (re.diff re.allchar (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.diff re.allchar (str.to_re "_")))))) (re.diff re.allchar (str.to_re "_")))) (re.opt (re.range "a" "z")))) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.range "a" "z"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)