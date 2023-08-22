;test regex (.*?)([AWMS]{2}|\d{1,2})(\s*[A-Z]{2}\s*)([A-Z3]{1,3}|\d{1,2})(?:A?)(\d{1,2})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union ((_ re.loop 2 2) (re.union (str.to_re "A") (re.union (str.to_re "W") (re.union (str.to_re "M") (str.to_re "S"))))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))))) (re.++ (re.union ((_ re.loop 1 3) (re.union (re.range "A" "Z") (str.to_re "3"))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "A")) (re.opt ((_ re.loop 1 2) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)