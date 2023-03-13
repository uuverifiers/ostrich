;test regex [a-z|A-Z|.]+@[a-z|A-Z]+\.[a-z]{3}\.[a-z]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.union (str.to_re "|") (re.union (re.range "A" "Z") (re.union (str.to_re "|") (str.to_re ".")))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (str.to_re "|") (re.range "A" "Z")))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "a" "z"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)