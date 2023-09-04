;test regex ^[\w][-.]+([A-B])[^a-z]{3}\.[0-9]{2,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (re.+ (re.union (str.to_re "-") (str.to_re "."))) (re.++ (re.range "A" "B") (re.++ ((_ re.loop 3 3) (re.diff re.allchar (re.range "a" "z"))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)