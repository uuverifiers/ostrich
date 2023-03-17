;test regex ^/fe/(?:[0-9A-Za-z]{2,30}?/?+)([$|#|\?]+?)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "f") (re.++ (str.to_re "e") (re.++ (str.to_re "/") (re.++ (re.++ ((_ re.loop 2 30) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.+ (re.opt (str.to_re "/")))) (re.+ (re.union (str.to_re "$") (re.union (str.to_re "|") (re.union (str.to_re "#") (re.union (str.to_re "|") (str.to_re "?"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)