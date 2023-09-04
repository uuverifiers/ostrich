;test regex [A-Za-z]{3}\s*\d{3}\s*(?:WP|NL|GP|EC)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.union (re.union (re.++ (str.to_re "W") (str.to_re "P")) (re.++ (str.to_re "N") (str.to_re "L"))) (re.++ (str.to_re "G") (str.to_re "P"))) (re.++ (str.to_re "E") (str.to_re "C")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)