;test regex (\[\[(Category|\w{2,3}(-\w+){0,2}):[^\[\]<>]+\]\]\s*)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "[") (re.++ (str.to_re "[") (re.++ (re.union (re.++ (str.to_re "C") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "y")))))))) (re.++ ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) ((_ re.loop 0 2) (re.++ (str.to_re "-") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))) (re.++ (str.to_re ":") (re.++ (re.+ (re.inter (re.diff re.allchar (str.to_re "[")) (re.inter (re.diff re.allchar (str.to_re "]")) (re.inter (re.diff re.allchar (str.to_re "<")) (re.diff re.allchar (str.to_re ">")))))) (re.++ (str.to_re "]") (re.++ (str.to_re "]") (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)