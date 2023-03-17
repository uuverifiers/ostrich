;test regex ([a-zA-Z]+|[\s\,\.\/\-]+|[\d]+)|(\(([\da-zA-Z]|[^)^(]+){1,}\))
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.union (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.union (str.to_re ",") (re.union (str.to_re ".") (re.union (str.to_re "/") (str.to_re "-"))))))) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "(") (re.++ (re.++ (re.* (re.union (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.inter (re.diff re.allchar (str.to_re ")")) (re.inter (re.diff re.allchar (str.to_re "^")) (re.diff re.allchar (str.to_re "("))))))) ((_ re.loop 1 1) (re.union (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.inter (re.diff re.allchar (str.to_re ")")) (re.inter (re.diff re.allchar (str.to_re "^")) (re.diff re.allchar (str.to_re "(")))))))) (str.to_re ")"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)