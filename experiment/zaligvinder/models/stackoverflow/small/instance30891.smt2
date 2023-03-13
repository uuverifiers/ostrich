;test regex [A-Z]{1,}([A-Z\s]{2,}|\d?)[A-Z]{1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "A" "Z"))) (re.++ (re.union (re.++ (re.* (re.union (re.range "A" "Z") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) (re.opt (re.range "0" "9"))) (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "A" "Z")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)