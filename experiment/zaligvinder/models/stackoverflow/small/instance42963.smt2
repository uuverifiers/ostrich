;test regex ^[^0-9][A-z0-9_]+([.][A-z0-9_]+)*[@][A-z0-9_]+([.][A-z0-9_]+)*[.][A-z]{2,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.++ (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "A" "z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.range "A" "z")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)