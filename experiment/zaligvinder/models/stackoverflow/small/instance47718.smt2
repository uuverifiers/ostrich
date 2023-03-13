;test regex r"(?:[KR]-*){1,3}(?:[^-]?-*){2}[KR]-*(?:[^-]-*){2}(?:[^-]?-*){2}[ILVM]-*[^-]-*[ILVF]"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 1 3) (re.++ (re.union (str.to_re "K") (str.to_re "R")) (re.* (str.to_re "-")))) (re.++ ((_ re.loop 2 2) (re.++ (re.opt (re.diff re.allchar (str.to_re "-"))) (re.* (str.to_re "-")))) (re.++ (re.union (str.to_re "K") (str.to_re "R")) (re.++ (re.* (str.to_re "-")) (re.++ ((_ re.loop 2 2) (re.++ (re.diff re.allchar (str.to_re "-")) (re.* (str.to_re "-")))) (re.++ ((_ re.loop 2 2) (re.++ (re.opt (re.diff re.allchar (str.to_re "-"))) (re.* (str.to_re "-")))) (re.++ (re.union (str.to_re "I") (re.union (str.to_re "L") (re.union (str.to_re "V") (str.to_re "M")))) (re.++ (re.* (str.to_re "-")) (re.++ (re.diff re.allchar (str.to_re "-")) (re.++ (re.* (str.to_re "-")) (re.++ (re.union (str.to_re "I") (re.union (str.to_re "L") (re.union (str.to_re "V") (str.to_re "F")))) (str.to_re "\u{22}"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)