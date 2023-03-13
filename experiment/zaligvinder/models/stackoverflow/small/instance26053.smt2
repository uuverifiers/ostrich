;test regex ^\s*\+?[0-9]\d?[- .]?(\([2-9]\d{2}\)|[2-9]\d{2})[- .]?\d{3}[- .]?\d{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.opt (str.to_re "+")) (re.++ (re.range "0" "9") (re.++ (re.opt (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re ".")))) (re.++ (re.union (re.++ (str.to_re "(") (re.++ (re.range "2" "9") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")")))) (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re ".")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "-") (re.union (str.to_re " ") (str.to_re ".")))) ((_ re.loop 4 4) (re.range "0" "9")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)