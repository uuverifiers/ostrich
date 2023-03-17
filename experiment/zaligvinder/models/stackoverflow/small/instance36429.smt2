;test regex [0-9A-Za-z]{2,12}/[0-9A-Za-z]{3,12}(?: [0-9A-Za-z]{1,12})?(?: \\d{1,3})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 2 12) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 3 12) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (re.opt (re.++ (str.to_re " ") ((_ re.loop 1 12) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))))) (re.opt (re.++ (str.to_re " ") (re.++ (str.to_re "\\") ((_ re.loop 1 3) (str.to_re "d"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)