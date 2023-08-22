;test regex \[\{\s{5}[A-Z]+\s{5}(\w+)[^\(]+\(([^,]+),[^0-9]+([0-9]+)\)[^\}]+\}\]
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "[") (re.++ (str.to_re "{") (re.++ ((_ re.loop 5 5) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.+ (re.range "A" "Z")) (re.++ ((_ re.loop 5 5) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "("))) (re.++ (str.to_re "(") (re.+ (re.diff re.allchar (str.to_re ","))))))))))) (re.++ (str.to_re ",") (re.++ (re.+ (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ")") (re.++ (re.+ (re.diff re.allchar (str.to_re "}"))) (re.++ (str.to_re "}") (str.to_re "]"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)