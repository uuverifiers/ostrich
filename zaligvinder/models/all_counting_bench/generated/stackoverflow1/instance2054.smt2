;test regex ^(\d{4}(\d([\dA-Z]|(\.(\d{1,2}|[A-Z]))|\d[A-Z]|[A-Z](\.\d[A-Z]?|[\dA-Z]\.\d))?|[A-Z]\.\d)|[A-Z]{3}-\d{4,6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.union (re.++ (re.range "0" "9") (re.opt (re.union (re.union (re.union (re.union (re.range "0" "9") (re.range "A" "Z")) (re.++ (str.to_re ".") (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.range "A" "Z")))) (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.++ (re.range "A" "Z") (re.union (re.++ (str.to_re ".") (re.++ (re.range "0" "9") (re.opt (re.range "A" "Z")))) (re.++ (re.union (re.range "0" "9") (re.range "A" "Z")) (re.++ (str.to_re ".") (re.range "0" "9")))))))) (re.++ (re.range "A" "Z") (re.++ (str.to_re ".") (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "-") ((_ re.loop 4 6) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)