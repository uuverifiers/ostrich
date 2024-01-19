;test regex ^[^-_]*([A-Za-z0-9]{3,})+[-_]?[^-_]*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "-")) (re.diff re.allchar (str.to_re "_")))) (re.++ (re.+ (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "_"))) (re.* (re.inter (re.diff re.allchar (str.to_re "-")) (re.diff re.allchar (str.to_re "_")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)