;test regex ^(\d+)-g([a-fA-F0-9]{7,40})(-dirty)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (str.to_re "g") (re.++ ((_ re.loop 7 40) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.opt (re.++ (str.to_re "-") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "r") (re.++ (str.to_re "t") (str.to_re "y")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)