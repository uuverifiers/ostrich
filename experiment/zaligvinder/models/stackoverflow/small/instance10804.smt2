;test regex (?:^|[^-])(left)\s*:\s*(\d+|auto)([a-z]{2})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "") (re.diff re.allchar (str.to_re "-"))) (re.++ (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "f") (str.to_re "t")))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re ":") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.union (re.+ (re.range "0" "9")) (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (str.to_re "o"))))) (re.opt ((_ re.loop 2 2) (re.range "a" "z")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)