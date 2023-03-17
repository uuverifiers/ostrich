;test regex ^([a-z0-9-]{2,30}, ?){0,4}[a-z0-9-]{2,30}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 0 4) (re.++ ((_ re.loop 2 30) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ",") (re.opt (str.to_re " "))))) ((_ re.loop 2 30) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)