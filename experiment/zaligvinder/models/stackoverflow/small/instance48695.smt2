;test regex ^((\d\d?|1[01]\d)(\.\d{1,2})?|120(\.0{1,2})?)(USD|GBP|EURO)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (str.to_re "01") (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (str.to_re "120") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (str.to_re "0")))))) (re.union (re.union (re.++ (str.to_re "U") (re.++ (str.to_re "S") (str.to_re "D"))) (re.++ (str.to_re "G") (re.++ (str.to_re "B") (str.to_re "P")))) (re.++ (str.to_re "E") (re.++ (str.to_re "U") (re.++ (str.to_re "R") (str.to_re "O"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)