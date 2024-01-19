;test regex (\/\*<<@\*\/){1}(.*){1}([a-z]|[A-Z]|[0-9]|_|\s)*(>>\*\/){1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "/") (re.++ (str.to_re "*") (re.++ (str.to_re "<") (re.++ (str.to_re "<") (re.++ (str.to_re "@") (re.++ (str.to_re "*") (str.to_re "/")))))))) (re.++ ((_ re.loop 1 1) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.* (re.union (re.union (re.union (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) (str.to_re "_")) (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))) ((_ re.loop 1 1) (re.++ (str.to_re ">") (re.++ (str.to_re ">") (re.++ (str.to_re "*") (str.to_re "/"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)