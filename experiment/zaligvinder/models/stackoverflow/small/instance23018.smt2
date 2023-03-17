;test regex ^([^0-9]+)([0-9]+.*?)?(?:\w)?([0-9]{5})(?:\w)?(.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.opt (re.++ (re.+ (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (re.opt (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.opt (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)