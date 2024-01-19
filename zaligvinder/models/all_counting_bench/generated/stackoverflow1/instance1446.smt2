;test regex ^id=\((\d+)\), (data\d+=\([a-zA-Z\d]{20}\)(, )?)+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (str.to_re "(") (re.++ (re.+ (re.range "0" "9")) (str.to_re ")"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.+ (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "=") (re.++ (str.to_re "(") (re.++ ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ (str.to_re ")") (re.opt (re.++ (str.to_re ",") (str.to_re " ")))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)