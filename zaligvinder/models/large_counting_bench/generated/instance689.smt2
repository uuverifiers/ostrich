;test regex ^(\.|[a-zA-Z0-9_\-]{1,255})(/[a-zA-Z0-9_/\-]{0,255})(\?.*)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re ".") ((_ re.loop 1 255) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re "-"))))))) (re.++ (re.++ (str.to_re "/") ((_ re.loop 0 255) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (re.union (str.to_re "/") (str.to_re "-")))))))) (re.opt (re.++ (str.to_re "?") (re.* (re.diff re.allchar (str.to_re "\n")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)