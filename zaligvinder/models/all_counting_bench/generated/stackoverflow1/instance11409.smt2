;test regex ^;[A-Za-z ]+(?:;[0-9]+){2}(?:;event[1-9][0-9]?=[0-9]+(?:\.[0-9]+)?)?(?:;eVar[1-9][0-9]?=[A-Za-z ]+)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re ";") (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re " ")))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re ";") (re.+ (re.range "0" "9")))) (re.++ (re.opt (re.++ (str.to_re ";") (re.++ (str.to_re "e") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (re.range "1" "9") (re.++ (re.opt (re.range "0" "9")) (re.++ (str.to_re "=") (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))))))))))))) (re.opt (re.++ (str.to_re ";") (re.++ (str.to_re "e") (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (re.range "1" "9") (re.++ (re.opt (re.range "0" "9")) (re.++ (str.to_re "=") (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (str.to_re " ")))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)