;test regex ^([A-Z]{2}|[A-Z][0-9]|[0-9][A-Z])\s*([0-9]{1,4}).*?\(([A-Z]{3})\)(?:.*?\(([A-Z]{3})\))?
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "(") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re ")") (re.opt (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "(") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re ")")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)