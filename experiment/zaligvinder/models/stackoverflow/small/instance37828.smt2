;test regex (([A-Za-z& ])*(\n|\r|\r\n)){5,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "&") (str.to_re " "))))) (re.union (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) ((_ re.loop 5 5) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "&") (str.to_re " "))))) (re.union (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}")) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)