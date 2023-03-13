;test regex ^(?:(?:[56]\d|7[01])(?:\.\d{1,15}|(?::(?:[0-5]\d|\d)){1,2})?|72(?:\.0{1,15}|(?::00){1,2})?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.++ (str.to_re "56") (re.range "0" "9")) (re.++ (str.to_re "7") (str.to_re "01"))) (re.opt (re.union (re.++ (str.to_re ".") ((_ re.loop 1 15) (re.range "0" "9"))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (re.union (re.++ (re.range "0" "5") (re.range "0" "9")) (re.range "0" "9"))))))) (re.++ (str.to_re "72") (re.opt (re.union (re.++ (str.to_re ".") ((_ re.loop 1 15) (str.to_re "0"))) ((_ re.loop 1 2) (re.++ (str.to_re ":") (str.to_re "00")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)