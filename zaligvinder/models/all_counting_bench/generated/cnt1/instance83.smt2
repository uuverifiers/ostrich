;test regex ^((file|folder)\.[0-9a-f]{16}\.[0-9A-F]{16}!\d+|folder\.[0-9a-f]{16})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))) (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "r"))))))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.++ (str.to_re "!") (re.+ (re.range "0" "9")))))))) (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re ".") ((_ re.loop 16 16) (re.union (re.range "0" "9") (re.range "a" "f")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)