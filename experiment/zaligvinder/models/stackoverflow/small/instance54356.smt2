;test regex [a-z ]+\s*(?:[^a-z]+?\d{2}/\d{2}[^a-z]+?\d+?[+-]?)+
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re " "))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.+ (re.++ (re.+ (re.diff re.allchar (re.range "a" "z"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.+ (re.diff re.allchar (re.range "a" "z"))) (re.++ (re.+ (re.range "0" "9")) (re.opt (re.union (str.to_re "+") (str.to_re "-"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)