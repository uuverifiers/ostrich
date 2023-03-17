;test regex ^(([a-z]{2,3})(-([A-Z][a-z]{3}))?(-([A-Z]{2}|[0-9]{3}))?)((-([a-zA-Z0-9]{5,8}|[0-9][a-zA-Z0-9]{3}))*)$|^(root)$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.++ ((_ re.loop 2 3) (re.range "a" "z")) (re.++ (re.opt (re.++ (str.to_re "-") (re.++ (re.range "A" "Z") ((_ re.loop 3 3) (re.range "a" "z"))))) (re.opt (re.++ (str.to_re "-") (re.union ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 3 3) (re.range "0" "9"))))))) (re.* (re.++ (str.to_re "-") (re.union ((_ re.loop 5 8) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (re.range "0" "9") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (str.to_re "t"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)