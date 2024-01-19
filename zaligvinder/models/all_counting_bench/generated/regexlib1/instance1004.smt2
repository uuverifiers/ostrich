;test regex (([A-Z]{1,2}[0-9][0-9A-Z]?)\ ([0-9][A-Z]{2}))|(GIR\ 0AA)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.++ (re.range "0" "9") (re.opt (re.union (re.range "0" "9") (re.range "A" "Z"))))) (re.++ (str.to_re " ") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))))) (re.++ (str.to_re "G") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.++ (str.to_re "A") (str.to_re "A"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)