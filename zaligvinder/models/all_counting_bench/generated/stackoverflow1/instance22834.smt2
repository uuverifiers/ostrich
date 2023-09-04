;test regex ("\\d?[A-Za-z]{2,3}\d?")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "d")) (re.++ ((_ re.loop 2 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.opt (re.range "0" "9")) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)