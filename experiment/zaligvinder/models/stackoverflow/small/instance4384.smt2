;test regex [A-Za-z]+\s?[0-9]+[A-Za-z0-9]{1,2}?
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.+ (re.range "0" "9")) ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)