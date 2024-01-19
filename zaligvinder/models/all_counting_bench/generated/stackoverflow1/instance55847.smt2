;test regex ^((?:\d{12}|arn:aws:iam::\d{12}:(?:root|user\/[A-Za-z0-9]+)),?\s*)*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.* (re.++ (re.union ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ (str.to_re "a") (re.++ (str.to_re "w") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (str.to_re "t")))) (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))))))))))))))))))))))) (re.++ (re.opt (str.to_re ",")) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)