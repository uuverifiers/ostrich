;test regex ^/arvados/v1/collections/([0-9a-fA-F]{32}\+[0-9]+)+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "v") (re.++ (str.to_re "1") (re.++ (str.to_re "/") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.+ (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re "+") (re.+ (re.range "0" "9")))))))))))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)