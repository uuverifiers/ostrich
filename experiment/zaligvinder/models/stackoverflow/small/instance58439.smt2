;test regex ^([a-z]{2,4}-[\d]{2,5}[, \n]{1,2})+\n{1}^[\w\n\s\*\-\.\:\'\,]+
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.++ ((_ re.loop 2 4) (re.range "a" "z")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 2 5) (re.range "0" "9")) ((_ re.loop 1 2) (re.union (str.to_re ",") (re.union (str.to_re " ") (str.to_re "\u{0a}")))))))) ((_ re.loop 1 1) (str.to_re "\u{0a}")))) (re.++ (str.to_re "") (re.+ (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (re.union (str.to_re "\u{0a}") (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (str.to_re "*") (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re ":") (re.union (str.to_re "\u{27}") (str.to_re ","))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)