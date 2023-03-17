;test regex (?:\.jpg|\.png|\.JPG|\.PNG){0}$
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 0) (re.union (re.union (re.union (re.++ (str.to_re ".") (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g")))) (re.++ (str.to_re ".") (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g"))))) (re.++ (str.to_re ".") (re.++ (str.to_re "J") (re.++ (str.to_re "P") (str.to_re "G"))))) (re.++ (str.to_re ".") (re.++ (str.to_re "P") (re.++ (str.to_re "N") (str.to_re "G")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)