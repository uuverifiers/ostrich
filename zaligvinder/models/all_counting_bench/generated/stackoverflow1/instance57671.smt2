;test regex ([A-Z]+) ([A-Z]+)? ([A-Z]+)? (\d{2,5})
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.range "A" "Z")) (re.++ (str.to_re " ") (re.++ (re.opt (re.+ (re.range "A" "Z"))) (re.++ (str.to_re " ") (re.++ (re.opt (re.+ (re.range "A" "Z"))) (re.++ (str.to_re " ") ((_ re.loop 2 5) (re.range "0" "9"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)