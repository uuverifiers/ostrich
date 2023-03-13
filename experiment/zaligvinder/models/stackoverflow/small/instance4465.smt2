;test regex (T)(\d{9})(T)(\d{0,19}\s{0,19}\w{0,19})O
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "T") (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "T") (re.++ (re.++ ((_ re.loop 0 19) (re.range "0" "9")) (re.++ ((_ re.loop 0 19) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) ((_ re.loop 0 19) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) (str.to_re "O")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)