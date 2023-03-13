;test regex \\(u|U)[a-zA-Z0-9]{4}|\\|\t|\n
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "\\") (re.++ (re.union (str.to_re "u") (str.to_re "U")) ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))) (str.to_re "\\")) (str.to_re "\u{09}")) (str.to_re "\u{0a}"))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)