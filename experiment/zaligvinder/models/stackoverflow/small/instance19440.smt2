;test regex ^0?\d{0,2}(.\d{0,8})?\s?%?$|^100(.0{0,8})?\s?%?$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "0")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (re.opt (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 0 8) (re.range "0" "9")))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.opt (str.to_re "%"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "100") (re.++ (re.opt (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 0 8) (str.to_re "0")))) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.opt (str.to_re "%")))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)