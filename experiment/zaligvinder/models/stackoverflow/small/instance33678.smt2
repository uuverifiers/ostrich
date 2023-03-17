;test regex REGEXP_LIKE (MyField, '^\*?PO\d{5}$', 'i');
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "M") (re.++ (str.to_re "y") (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (str.to_re "d"))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "\u{27}")))) (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "*")) (re.++ (str.to_re "P") (re.++ (str.to_re "O") ((_ re.loop 5 5) (re.range "0" "9"))))))) (re.++ (str.to_re "") (str.to_re "\u{27}"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "i") (str.to_re "\u{27}")))))) (str.to_re ";"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)