;test regex ^arn:aws:kms:[a-z]{2}-[a-z]+-\d{1}:[0-9]{12}:key/[a-z0-9-]{36}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ (str.to_re "a") (re.++ (str.to_re "w") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ (str.to_re "k") (re.++ (str.to_re "m") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "-") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (str.to_re "k") (re.++ (str.to_re "e") (re.++ (str.to_re "y") (re.++ (str.to_re "/") ((_ re.loop 36 36) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-"))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)