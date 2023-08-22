;test regex ([^a-zA-Z]+[^0-9]{0,2})+(\s*\d{0,4}\s*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.inter (re.diff re.allchar (re.range "a" "z")) (re.diff re.allchar (re.range "A" "Z")))) ((_ re.loop 0 2) (re.diff re.allchar (re.range "0" "9"))))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 0 4) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)