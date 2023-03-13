;test regex ([BKNPQR][ld][a-h][1-8])|((?:(?:[a-h][1-8]\s*){2})+)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.union (str.to_re "B") (re.union (str.to_re "K") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "Q") (str.to_re "R")))))) (re.++ (re.union (str.to_re "l") (str.to_re "d")) (re.++ (re.range "a" "h") (re.range "1" "8")))) (re.+ ((_ re.loop 2 2) (re.++ (re.range "a" "h") (re.++ (re.range "1" "8") (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)