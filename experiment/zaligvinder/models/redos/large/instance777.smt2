;test regex ^\/[a-z]\/(\d{8})\/(\w{40})\/(\d{2,3})x(\d{2,3})-(\w{4}).(\w{3})(?:\?(.*))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (re.range "a" "z") (re.++ (str.to_re "/") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 40 40) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "x") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.opt (re.++ (str.to_re "?") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)