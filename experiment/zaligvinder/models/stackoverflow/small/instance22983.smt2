;test regex [.\n]*SB\s*\d{3,}[.\n]*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re ".") (str.to_re "\u{0a}"))) (re.++ (str.to_re "S") (re.++ (str.to_re "B") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.* (re.union (str.to_re ".") (str.to_re "\u{0a}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)