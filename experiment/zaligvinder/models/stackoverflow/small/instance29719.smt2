;test regex (NP|ZP|SP|...): \d+\D\d+([.,]\d{1,4})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.++ (str.to_re "N") (str.to_re "P")) (re.++ (str.to_re "Z") (str.to_re "P"))) (re.++ (str.to_re "S") (str.to_re "P"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.+ (re.range "0" "9")) (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 4) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)