;test regex ([^\.]+)\.(r(ar|\d\d)|\d{3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.+ (re.diff re.allchar (str.to_re "."))) (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "r") (re.union (re.++ (str.to_re "a") (str.to_re "r")) (re.++ (re.range "0" "9") (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)