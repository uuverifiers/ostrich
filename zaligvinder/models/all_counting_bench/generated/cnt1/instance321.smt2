;test regex [A-Z]+ [0-9A-Za-z/\s]{2,45} - [A-Z][a-z]+ 20[0-9]{2}.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "A" "Z")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 45) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "/") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.++ (re.range "A" "Z") (re.++ (re.+ (re.range "a" "z")) (re.++ (str.to_re " ") (re.++ (str.to_re "20") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)