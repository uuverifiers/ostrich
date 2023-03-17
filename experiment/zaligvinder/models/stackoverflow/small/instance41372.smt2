;test regex ^\d{4}-((0\d)|(1[012]))-(([012]\d)|3[01]) (([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9]):([0-5]?[0-9]).([0-9]?[0-9]?[0-9])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (str.to_re "-") (re.++ (re.union (re.++ (str.to_re "012") (re.range "0" "9")) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re " ") (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (re.++ (str.to_re ":") (re.++ (re.++ (re.opt (re.range "0" "5")) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ (re.++ (re.opt (re.range "0" "5")) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.opt (re.range "0" "9")) (re.++ (re.opt (re.range "0" "9")) (re.range "0" "9")))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)