;test regex ((([1-2]?[0-9]?[0-9]\.){1,3}([1-2]?[0-9]?[0-9])?)|any)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 3) (re.++ (re.opt (re.range "1" "2")) (re.++ (re.opt (re.range "0" "9")) (re.++ (re.range "0" "9") (str.to_re "."))))) (re.opt (re.++ (re.opt (re.range "1" "2")) (re.++ (re.opt (re.range "0" "9")) (re.range "0" "9"))))) (re.++ (str.to_re "a") (re.++ (str.to_re "n") (str.to_re "y"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)