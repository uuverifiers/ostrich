;test regex ^([a-z0-9])(([\-.]|[_]+)?([a-z0-9]+))*(@)([a-z0-9])((([-]+)?([a-z0-9]+))?)*((.[a-z]{2,3})?(.[a-z]{2,6}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.* (re.++ (re.opt (re.union (re.union (str.to_re "-") (str.to_re ".")) (re.+ (str.to_re "_")))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re "@") (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.* (re.opt (re.++ (re.opt (re.+ (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (re.opt (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 3) (re.range "a" "z")))) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 6) (re.range "a" "z")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)