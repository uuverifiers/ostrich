;test regex DISCOVERY,\d,[0-9A-F]{12},\d,[+-][\d]{3},\d,[\d]{4}(.*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "D") (re.++ (str.to_re "I") (re.++ (str.to_re "S") (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "V") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (str.to_re "Y"))))))))) (re.++ (str.to_re ",") (re.range "0" "9"))) (re.++ (str.to_re ",") ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "A" "F"))))) (re.++ (str.to_re ",") (re.range "0" "9"))) (re.++ (str.to_re ",") (re.++ (re.union (str.to_re "+") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re ",") (re.range "0" "9"))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)