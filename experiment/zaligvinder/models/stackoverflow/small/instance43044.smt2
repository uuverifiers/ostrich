;test regex ^8759(?:\.[0-5]\d?)?$|^(?:(?:(?:|[1-9]|[1-9]\d|[1-7]\d{2})\d|8[0-7][0-5][0-8])(?:\.\d{1,2})?)$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "8759") (re.opt (re.++ (str.to_re ".") (re.++ (re.range "0" "5") (re.opt (re.range "0" "9"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "") (re.union (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.++ (re.range "1" "7") ((_ re.loop 2 2) (re.range "0" "9"))))) (str.to_re "")) (re.range "0" "9")) (re.++ (str.to_re "8") (re.++ (re.range "0" "7") (re.++ (re.range "0" "5") (re.range "0" "8"))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)