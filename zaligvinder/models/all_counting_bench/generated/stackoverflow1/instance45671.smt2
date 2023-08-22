;test regex ^([a-tA-T]|[v-zV-Z])\d{2}(\.[a-zA-Z0-9]{1,4})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.range "a" "t") (re.range "A" "T")) (re.union (re.range "v" "z") (re.range "V" "Z"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)